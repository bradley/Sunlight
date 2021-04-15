import Combine
import Foundation

extension SunlightRestClient {
  public class DownloadRequest: NSObject, URLSessionTaskDelegate {
    // The base SunlightRestClient client.
    public let client: SunlightRestClient

    // Request details.
    public var route: String
    public var params: RestParams
    public var headers: [String: String]

    // Overrides for defaults set within client for use by this request.
    public var requestTimeoutInterval: TimeInterval?
    public var sessionConfiguration: URLSessionConfiguration?
    public var operationQueue: OperationQueue?

    public init(
      client: SunlightRestClient,
      route: String,
      params: RestParams,
      headers: [String: String] = [String: String](),
      requestTimeoutInterval: TimeInterval? = nil,
      sessionConfiguration: URLSessionConfiguration? = nil,
      operationQueue: OperationQueue? = nil
    ) {
      self.client = client
      self.route = route
      self.params = params
      self.headers = headers
      self.requestTimeoutInterval = requestTimeoutInterval
      self.sessionConfiguration = sessionConfiguration
      self.operationQueue = operationQueue
    }

    public func publisher() -> AnyPublisher<(URL?, Progress), Error> {
      guard let urlRequest = buildRequest() else {
        return Fail(error: RestError.unableToParseRequest as Error)
          .eraseToAnyPublisher()
      }

      let urlSession = URLSession(
        configuration: self.finalSessionConfiguration,
        delegate: self,
        delegateQueue: self.finalOperationQueue
      )

      let callPublisher: AnyPublisher<(URL?, Progress), Error> = urlSession
        .sunlightDownloadTaskPublisher(for: urlRequest)
        .sunlightMapErrorToRestError()
        .eraseToAnyPublisher()

      return callPublisher
        .eraseToAnyPublisher()
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

    private func buildRequest() -> URLRequest? {
      let urlString = getURLWithParams()

      guard let url = URL(string: urlString) else {
        return nil
      }

      var request = URLRequest(url: url)
      request.httpMethod = RestHttpVerb.get.rawValue

      if let timeoutInterval = self.finalRequestTimeoutInterval {
        request.timeoutInterval = timeoutInterval
      }

      for (key, value) in self.finalRequestHeaders {
        request.setValue(value, forHTTPHeaderField: key)
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
  }
}
