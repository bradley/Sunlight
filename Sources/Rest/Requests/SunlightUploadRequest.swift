import Combine
import Foundation

extension SunlightRestClient {
  public class UploadRequest: NSObject, URLSessionTaskDelegate {

    // The base SunlightRestClient client.
    public let client: SunlightRestClient

    // Request details.
    public var route: String
    public var params: RestParams
    public var multipartData: [RestMultipartData]
    public var headers: [String: String]

    // Overrides for defaults set within client for use by this request.
    public var requestTimeoutInterval: TimeInterval?
    public var sessionConfiguration: URLSessionConfiguration?
    public var operationQueue: OperationQueue?

    public init(
      client: SunlightRestClient,
      route: String,
      params: RestParams,
      multipartData: [RestMultipartData],
      headers: [String: String] = [String: String](),
      requestTimeoutInterval: TimeInterval? = nil,
      sessionConfiguration: URLSessionConfiguration? = nil,
      operationQueue: OperationQueue? = nil
    ) {
      self.client = client
      self.route = route
      self.params = params
      self.multipartData = multipartData
      self.headers = headers
      self.requestTimeoutInterval = requestTimeoutInterval
      self.sessionConfiguration = sessionConfiguration
      self.operationQueue = operationQueue
    }

    public func patchPublisher() -> AnyPublisher<(Data?, Progress), Error> {
      return self.publisher(httpVerb: .patch)
    }

    public func postPublisher() -> AnyPublisher<(Data?, Progress), Error> {
      return self.publisher(httpVerb: .post)
    }

    public func putPublisher() -> AnyPublisher<(Data?, Progress), Error> {
      return self.publisher(httpVerb: .put)
    }

    private func publisher(
      httpVerb: RestHttpVerb
    ) -> AnyPublisher<(Data?, Progress), Error> {
      guard let urlRequest = buildRequest(httpVerb: httpVerb) else {
        return Fail(error: RestError.unableToParseRequest as Error)
          .eraseToAnyPublisher()
      }

      let urlSession = URLSession(
        configuration: self.finalSessionConfiguration,
        delegate: self,
        delegateQueue: self.finalOperationQueue
      )

      let callPublisher: AnyPublisher<(Data?, Progress), Error> = urlSession
        .sunlightMultipartUploadTaskPublisher(for: urlRequest)
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

    private func buildRequest(
      httpVerb: RestHttpVerb
    ) -> URLRequest? {
      let urlString = self.client.baseURL + self.route

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

      request = requestWithMultipartData(request: &request)

      return request
    }

    private func requestWithMultipartData(
      request: inout URLRequest
    ) -> URLRequest {
      // Construct a unique boundary to separate values.
      let boundary = "Boundary-\(UUID().uuidString)"

      request.setValue(
        "multipart/form-data; boundary=\(boundary)",
        forHTTPHeaderField: "Content-Type"
      )

      request.httpBody = self.buildMultipartHttpBody(
        params: self.params,
        multiparts: self.multipartData,
        boundary: boundary
      )

      return request
    }

    private func buildMultipartHttpBody(
      params: RestParams,
      multiparts: [RestMultipartData],
      boundary: String
    ) -> Data {
      // Combine all multiparts together.
      let allMultiparts: [SunlightRestHttpBodyConvertible] =
        [params] + multiparts
      let boundaryEnding = "--\(boundary)--".data(using: .utf8)!

      // Convert multiparts to boundary-seperated Data and combine them.
      return allMultiparts
        .map { (multipart: SunlightRestHttpBodyConvertible) -> Data in
          return multipart.buildHttpBodyPart(boundary: boundary)
        }
        .reduce(Data.init(), +)
        + boundaryEnding
    }
  }
}
