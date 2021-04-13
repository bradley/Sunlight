import Combine
import Foundation

// Data Requests
public extension SunlightRestClient {

  func get(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    parameterEncoding: RestParameterEncoding? = nil,
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Data, Error> {
    return DataRequest(
      client: self,
      route: route,
      params: params,
      headers: headers,
      parameterEncoding: parameterEncoding,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .getPublisher()
  }

  func post(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    parameterEncoding: RestParameterEncoding? = nil,
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Data, Error> {
    return DataRequest(
      client: self,
      route: route,
      params: params,
      headers: headers,
      parameterEncoding: parameterEncoding,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .postPublisher()
  }

  func put(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    parameterEncoding: RestParameterEncoding? = nil,
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Data, Error> {
    return DataRequest(
      client: self,
      route: route,
      params: params,
      headers: headers,
      parameterEncoding: parameterEncoding,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .putPublisher()
  }

  func patch(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    parameterEncoding: RestParameterEncoding? = nil,
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Data, Error> {
    return DataRequest(
      client: self,
      route: route,
      params: params,
      headers: headers,
      parameterEncoding: parameterEncoding,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .patchPublisher()
  }

  func delete(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    parameterEncoding: RestParameterEncoding? = nil,
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<Data, Error> {
    return DataRequest(
      client: self,
      route: route,
      params: params,
      headers: headers,
      parameterEncoding: parameterEncoding,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .deletePublisher()
  }

  func download(
    _ route: String,
    params: RestParams = RestParams(),
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(URL?, Progress), Error> {
    return DownloadRequest(
      client: self,
      route: route,
      params: params,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .publisher()
  }

  func uploadPatch(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: RestMultipartData,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(Data?, Progress), Error> {
    return uploadPatch(
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
  ) -> AnyPublisher<(Data?, Progress), Error> {
    return UploadRequest(
      client: self,
      route: route,
      params: params,
      multipartData: multipartData,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .patchPublisher()
  }

  func uploadPost(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: RestMultipartData,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(Data?, Progress), Error> {
    return uploadPost(
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
  ) -> AnyPublisher<(Data?, Progress), Error> {
    return UploadRequest(
      client: self,
      route: route,
      params: params,
      multipartData: multipartData,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .postPublisher()
  }

  func uploadPut(
    _ route: String,
    params: RestParams = RestParams(),
    multipartData: RestMultipartData,
    headers: [String: String] = [String: String](),
    requestTimeoutInterval: TimeInterval? = nil,
    sessionConfiguration: URLSessionConfiguration? = nil,
    operationQueue: OperationQueue? = nil
  ) -> AnyPublisher<(Data?, Progress), Error> {
    return uploadPut(
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
  ) -> AnyPublisher<(Data?, Progress), Error> {
    return UploadRequest(
      client: self,
      route: route,
      params: params,
      multipartData: multipartData,
      headers: headers,
      requestTimeoutInterval: requestTimeoutInterval,
      sessionConfiguration: sessionConfiguration,
      operationQueue: operationQueue
    )
    .putPublisher()
  }
}
