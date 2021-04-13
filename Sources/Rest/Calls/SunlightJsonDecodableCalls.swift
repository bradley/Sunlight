import Combine
import Foundation

// JSON Decodable Requests
// Calls Data Publishers internally, mapping published responses to JSON
// Decodable results.
public extension SunlightRestClient {

  func get<T: SunlightRestJsonDecodable>(
    _ route: String,
    params: RestParams = RestParams(),
    keypath: String? = nil,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<T, Error> {
    return get(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJsonDecodable(keypath: keypath)
  }

  // Array version
  func get<T: SunlightRestJsonDecodable>(
    _ route: String,
    params: RestParams = RestParams(),
    keypath: String? = nil,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<[T], Error> {
    return get(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJsonDecodableArray(keypath: keypath)
  }

  func post<T: SunlightRestJsonDecodable>(
    _ route: String,
    params: RestParams = RestParams(),
    keypath: String? = nil,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<T, Error> {
    return post(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJsonDecodable(keypath: keypath)
  }

  func put<T: SunlightRestJsonDecodable>(
    _ route: String,
    params: RestParams = RestParams(),
    keypath: String? = nil,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<T, Error> {
    return put(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJsonDecodable(keypath: keypath)
  }

  func patch<T: SunlightRestJsonDecodable>(
    _ route: String,
    params: RestParams = RestParams(),
    keypath: String? = nil,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<T, Error> {
    return patch(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJsonDecodable(keypath: keypath)
  }

  func delete<T: SunlightRestJsonDecodable>(
    _ route: String,
    params: RestParams = RestParams(),
    keypath: String? = nil,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<T, Error> {
    return delete(
      route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJsonDecodable(keypath: keypath)
  }

  func uploadPatch<T: SunlightRestJsonDecodable>(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: RestMultipartData,
    keypath: String? = nil,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(T?, Progress), Error> {
    uploadPatch(
      route,
      params: params,
      multipartData: [multipartData],
      keypath: keypath,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
  }

  func uploadPatch<T: SunlightRestJsonDecodable>(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: [RestMultipartData],
    keypath: String? = nil,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(T?, Progress), Error> {
    uploadPatch(
      route,
      params: params,
      multipartData: multipartData,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJsonDecodable(keypath: keypath)
  }

  func uploadPost<T: SunlightRestJsonDecodable>(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: RestMultipartData,
    keypath: String? = nil,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(T?, Progress), Error> {
    uploadPost(
      route,
      params: params,
      multipartData: [multipartData],
      keypath: keypath,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
  }

  func uploadPost<T: SunlightRestJsonDecodable>(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: [RestMultipartData],
    keypath: String? = nil,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(T?, Progress), Error> {
    uploadPost(
      route,
      params: params,
      multipartData: multipartData,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJsonDecodable(keypath: keypath)
  }

  func uploadPut<T: SunlightRestJsonDecodable>(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: RestMultipartData,
    keypath: String? = nil,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(T?, Progress), Error> {
    uploadPut(
      route,
      params: params,
      multipartData: [multipartData],
      keypath: keypath,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
  }

  func uploadPut<T: SunlightRestJsonDecodable>(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: [RestMultipartData],
    keypath: String? = nil,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(T?, Progress), Error> {
    uploadPut(
      route,
      params: params,
      multipartData: multipartData,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .toJsonDecodable(keypath: keypath)
  }
}

// JSON to JSON Decodable
fileprivate extension Publisher where Output == Any {

  func toJsonDecodable<T: SunlightRestJsonDecodable>(
    keypath: String? = nil
  ) -> AnyPublisher<T, Error> {
    tryMap { data -> T in
      try SunlightRestClient.SunlightRestJsonDecodableParser()
        .toModel(data, keypath: keypath)
    }
    .receive(on: RunLoop.main)
    .eraseToAnyPublisher()
  }

  func toJsonDecodableArray<T: SunlightRestJsonDecodable>(
    keypath: String? = nil
  ) -> AnyPublisher<[T], Error> {
    tryMap { data -> [T] in
      SunlightRestClient.SunlightRestJsonDecodableParser()
        .toModels(data, keypath: keypath)
    }
    .receive(on: RunLoop.main)
    .eraseToAnyPublisher()
  }
}

fileprivate extension Publisher where Output == (Any?, Progress) {

  func toJsonDecodable<T: SunlightRestJsonDecodable>(
    keypath: String? = nil
  ) -> AnyPublisher<(T?, Progress), Error> {
    tryMap { (data, progress) -> (T?, Progress) in
      var decoded: T?

      if let data = data {
        decoded = try SunlightRestClient.SunlightRestJsonDecodableParser()
          .toModel(data, keypath: keypath)
      }

      return (decoded, progress)
    }
    .eraseToAnyPublisher()
  }
}
