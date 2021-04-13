import Combine
import Foundation

// JSON Requests.
// Calls Data Publishers internally, mapping published responses to JSON data.
public extension SunlightRestClient {

  func get(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Any, Error> {
    get(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJSON()
  }

  func post(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Any, Error> {
    post(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJSON()
  }

  func put(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Any, Error> {
    put(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJSON()
  }

  func patch(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Any, Error> {
    patch(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJSON()
  }

  func delete(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Any, Error> {
    delete(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJSON()
  }

  func uploadPatch(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: RestMultipartData,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(Any?, Progress), Error> {
    uploadPatch(
      route,
      params: params,
      multipartData: [multipartData],
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
  }

  func uploadPatch(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: [RestMultipartData],
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(Any?, Progress), Error> {
    uploadPatch(
      route,
      params: params,
      multipartData: multipartData,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJSON()
  }

  func uploadPost(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: RestMultipartData,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(Any?, Progress), Error> {
    uploadPost(
      route,
      params: params,
      multipartData: [multipartData],
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
  }

  func uploadPost(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: [RestMultipartData],
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(Any?, Progress), Error> {
    uploadPost(
      route,
      params: params,
      multipartData: multipartData,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJSON()
  }

  func uploadPut(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: RestMultipartData,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(Any?, Progress), Error> {
    uploadPut(
      route,
      params: params,
      multipartData: [multipartData],
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
  }

  func uploadPut(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: [RestMultipartData],
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(Any?, Progress), Error> {
    uploadPut(
      route,
      params: params,
      multipartData: multipartData,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJSON()
  }
}

// Data to JSON
fileprivate extension Publisher where Output == Data {

  func toJSON() -> AnyPublisher<Any, Error> {
    tryMap { data -> Any in
      return try JSONSerialization.jsonObject(with: data, options: [])
    }
    .eraseToAnyPublisher()
  }
}

fileprivate extension Publisher where Output == (Data?, Progress) {

  func toJSON() -> AnyPublisher<(Any?, Progress), Error> {
    tryMap { (data, progress) -> (Any?, Progress) in
      var json: Any?

      if let data = data {
        json = try JSONSerialization.jsonObject(with: data, options: [])
      }

      return (json, progress)
    }
    .eraseToAnyPublisher()
  }
}
