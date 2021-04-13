import Combine
import Foundation

public struct SunlightRestClientDefaults {

  public static var defaultHeaders: [String: String] = [String: String]()

  public static var defaultParameterEncoding:
    SunlightRestClient.RestParameterEncoding = .urlEncoded

  public static var defaultRequestTimeoutInterval: TimeInterval? = nil

  public static var defaultOperationQueue: OperationQueue = {
    // Create a `OperationQueue` instance for scheduling the delegate calls and
    // completion handlers.
    let operationQueue = OperationQueue()
    operationQueue.maxConcurrentOperationCount = 3
    operationQueue.qualityOfService = .userInitiated

    return operationQueue
  }()

  public static var defaultSessionConfiguration: URLSessionConfiguration = {
    // Configure the default URLSessionConfiguration.
    let sessionConfiguration = URLSessionConfiguration.default

    // Wait up to 30 seconds for connection if connection is temporarily
    // unavailable.
    sessionConfiguration.timeoutIntervalForResource = 30
    sessionConfiguration.waitsForConnectivity = true

    return sessionConfiguration
  }()
}

public struct SunlightRestClient {
  public let baseURL: String
  public var headers: [String: String]

  public var parameterEncoding: RestParameterEncoding
  public var requestTimeoutInterval: TimeInterval?

  public var sessionConfiguration: URLSessionConfiguration
  public var operationQueue: OperationQueue

  public init(
    baseURL: String,
    headers: [String: String] =
      SunlightRestClientDefaults.defaultHeaders,
    parameterEncoding: RestParameterEncoding =
      SunlightRestClientDefaults.defaultParameterEncoding,
    requestTimeoutInterval: TimeInterval? =
      SunlightRestClientDefaults.defaultRequestTimeoutInterval,
    sessionConfiguration: URLSessionConfiguration =
      SunlightRestClientDefaults.defaultSessionConfiguration,
    operationQueue: OperationQueue =
      SunlightRestClientDefaults.defaultOperationQueue
  ) {
    self.baseURL = baseURL
    self.headers = headers
    self.parameterEncoding = parameterEncoding
    self.requestTimeoutInterval = requestTimeoutInterval
    self.sessionConfiguration = sessionConfiguration
    self.operationQueue = operationQueue
  }
}
