import Combine
import Foundation

// Void Requests
// Calls Data Publishers internally, mapping published responses to Void.
public extension SunlightRestClient {

  func get(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Void, Error> {
    get(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toVoid()
  }

  func post(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Void, Error> {
    post(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toVoid()
  }

  func put(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Void, Error> {
    put(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toVoid()
  }

  func patch(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Void, Error> {
    patch(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toVoid()
  }

  func delete(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Void, Error> {
    delete(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toVoid()
  }

  func uploadPatch(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: RestMultipartData,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(Void?, Progress), Error> {
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
  ) -> AnyPublisher<(Void?, Progress), Error> {
    uploadPatch(
      route,
      params: params,
      multipartData: multipartData,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toVoid()
  }

  func uploadPost(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: RestMultipartData,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(Void?, Progress), Error> {
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
  ) -> AnyPublisher<(Void?, Progress), Error> {
    uploadPost(
      route,
      params: params,
      multipartData: multipartData,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toVoid()
  }

  func uploadPut(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: RestMultipartData,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(Void?, Progress), Error> {
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
  ) -> AnyPublisher<(Void?, Progress), Error> {
    uploadPut(
      route,
      params: params,
      multipartData: multipartData,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toVoid()
  }
}

// Data to Void
fileprivate extension Publisher where Output == Data {

  func toVoid() -> AnyPublisher<Void, Error> {
    tryMap { (data: Data) -> Void in () }
    .eraseToAnyPublisher()
  }
}

fileprivate extension Publisher where Output == (Data?, Progress) {

  func toVoid() -> AnyPublisher<(Void?, Progress), Error> {
    tryMap { (data, progress) -> (Void?, Progress) in
      var void: Void?

      if let _ = data {
        void = ()
      }

      return (void, progress)
    }
    .eraseToAnyPublisher()
  }
}
