import Combine
import Foundation

extension SunlightRestClient {
  public class DataRequest: NSObject, URLSessionTaskDelegate {

    // The base SunlightRestClient client.
    public let client: SunlightRestClient

    // Request details.
    public var route: String
    public var params: RestParams
    public var headers: [String: String]

    // Overrides for defaults set within client for use by this request.
    public var parameterEncoding: RestParameterEncoding?
    public var requestTimeoutInterval: TimeInterval?
    public var sessionConfiguration: URLSessionConfiguration?
    public var operationQueue: OperationQueue?

    public init(
      client: SunlightRestClient,
      route: String,
      params: RestParams,
      headers: [String: String] = [String: String](),
      parameterEncoding: RestParameterEncoding? = nil,
      requestTimeoutInterval: TimeInterval? = nil,
      sessionConfiguration: URLSessionConfiguration? = nil,
      operationQueue: OperationQueue? = nil
    ) {
      self.client = client
      self.route = route
      self.params = params
      self.headers = headers
      self.parameterEncoding = parameterEncoding
      self.requestTimeoutInterval = requestTimeoutInterval
      self.sessionConfiguration = sessionConfiguration
      self.operationQueue = operationQueue
    }

    public func deletePublisher() -> AnyPublisher<Data, Error> {
      return self.publisher(httpVerb: .delete)
    }

    public func getPublisher() -> AnyPublisher<Data, Error> {
      return self.publisher(httpVerb: .get)
    }

    public func patchPublisher() -> AnyPublisher<Data, Error> {
      return self.publisher(httpVerb: .patch)
    }

    public func postPublisher() -> AnyPublisher<Data, Error> {
      return self.publisher(httpVerb: .post)
    }

    public func putPublisher() -> AnyPublisher<Data, Error> {
      return self.publisher(httpVerb: .put)
    }

    private func publisher(
      httpVerb: RestHttpVerb
    ) -> AnyPublisher<Data, Error> {
      guard let urlRequest = buildRequest(httpVerb: httpVerb) else {
        return Fail(error: RestError.unableToParseRequest as Error)
          .eraseToAnyPublisher()
      }

      let urlSession = URLSession(
        configuration: self.finalSessionConfiguration,
        delegate: self,
        delegateQueue: self.finalOperationQueue
      )

      return urlSession
        .dataTaskPublisher(for: urlRequest)
        .sunlightMapErrorToRestError()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    private var finalParameterEncoding: RestParameterEncoding {
      if let parameterEncoding = self.parameterEncoding {
        return parameterEncoding
      } else {
        return self.client.parameterEncoding
      }
    }

    private var finalRequestHeaders: [String: String] {
      var requestHeaders: [String: String] = [String: String]()

      // Merge client headers and request headers, allowing request headers to
      // override any duplicates in client headers.
      requestHeaders.merge(self.client.headers) { (_, new) in new }
      requestHeaders.merge(self.headers) { (_, new) in new }

      return requestHeaders
    }

    private var finalRequestTimeoutInterval: TimeInterval? {
      if let requestTimeoutInterval = self.requestTimeoutInterval {
        return requestTimeoutInterval
      } else {
        return self.client.requestTimeoutInterval
      }
    }

    private var finalSessionConfiguration: URLSessionConfiguration {
      if let sessionConfiguration = self.sessionConfiguration {
        return sessionConfiguration
      } else {
        return self.client.sessionConfiguration
      }
    }

    private var finalOperationQueue: OperationQueue {
      if let operationQueue = self.operationQueue {
        return operationQueue
      } else {
        return self.client.operationQueue
      }
    }

    private func buildRequest(
      httpVerb: RestHttpVerb
    ) -> URLRequest? {
      var urlString: String

      if httpVerb == .get {
        urlString = self.getURLWithParams()
      } else {
        urlString = self.client.baseURL + self.route
      }

      guard let url = URL(string: urlString) else {
        return nil
      }

      var request = URLRequest(url: url)
      request.httpMethod = httpVerb.rawValue

      if let timeoutInterval = self.finalRequestTimeoutInterval {
        request.timeoutInterval = timeoutInterval
      }

      for (key, value) in self.finalRequestHeaders {
        request.setValue(value, forHTTPHeaderField: key)
      }

      if httpVerb != .get {
        switch self.finalParameterEncoding {
          case .urlEncoded:
            request.setValue(
              "application/x-www-form-urlencoded",
              forHTTPHeaderField: "Content-Type"
            )
            request.httpBody = percentEncodedString().data(using: .utf8)
          case .json:
            request.setValue(
              "application/json",
              forHTTPHeaderField: "Content-Type"
            )
            let jsonData = try? JSONSerialization.data(withJSONObject: params)
            request.httpBody = jsonData
        }
      }

      return request
    }

    private func getURLWithParams() -> String {
      let urlString = self.client.baseURL + self.route

      guard let url = URL(string: urlString) else {
        return urlString
      }

      if var urlComponents = URLComponents(
          url: url,
          resolvingAgainstBaseURL: false
      ) {
        var queryItems = urlComponents.queryItems ?? [URLQueryItem]()

        self.params.forEach { param in
          // In arrayParam[] syntax
          if let array = param.value as? [CustomStringConvertible] {
            array.forEach {
              queryItems.append(
                URLQueryItem(
                  name: "\(param.key)[]",
                  value: "\($0)"
                )
              )
            }
          }
          queryItems.append(
            URLQueryItem(
              name: param.key,
              value: "\(param.value)"
            )
          )
        }

        urlComponents.queryItems = queryItems

        return urlComponents.url?.absoluteString ?? urlString
      }

      return urlString
    }

    func percentEncodedString() -> String {
      return params.map { key, value in
        let escapedKey = "\(key)".addingPercentEncoding(
          withAllowedCharacters: .urlQueryValueAllowed
        ) ?? ""

        if let array = value as? [CustomStringConvertible] {
          return array.map { entry in
            let escapedValue = "\(entry)".addingPercentEncoding(
              withAllowedCharacters: .urlQueryValueAllowed
            ) ?? ""

            return "\(key)[]=\(escapedValue)" }.joined(separator: "&")
        } else {
          let escapedValue = "\(value)".addingPercentEncoding(
            withAllowedCharacters: .urlQueryValueAllowed
          ) ?? ""

          return "\(escapedKey)=\(escapedValue)"
        }
      }
      .joined(separator: "&")
    }
  }
}

// Thanks to https://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method
fileprivate extension CharacterSet {
  static let urlQueryValueAllowed: CharacterSet = {
    // Does not include "?" or "/" due to RFC 3986 - Section 3.4
    let generalDelimitersToEncode = ":#[]@"
    let subDelimitersToEncode = "!$&'()*+,;="
    var allowed = CharacterSet.urlQueryAllowed

    allowed.remove(
      charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)"
    )

    return allowed
  }()
}
