import Combine
import Foundation

extension Publisher where Self == URLSession.SunlightDownloadTaskPublisher {

  func sunlightMapErrorToRestError() -> AnyPublisher<URL, Error> {
    tryMap { (url: URL, response: URLResponse) -> URL in
      if let httpURLResponse = response as? HTTPURLResponse {
        if !(200...299 ~= httpURLResponse.statusCode) {
          let error = SunlightRestClient.RestError(
            errorCode: httpURLResponse.statusCode
          )

          throw error
        }
      }

      return url
    }
    .mapError { error -> SunlightRestClient.RestError in
      return SunlightRestClient.RestError(error: error)
    }
    .eraseToAnyPublisher()
  }
}

extension Publisher where Self == URLSession.DataTaskPublisher {

  func sunlightMapErrorToRestError() -> AnyPublisher<Data, Error> {
    tryMap { (data: Data, response: URLResponse) -> Data in
      if let httpURLResponse = response as? HTTPURLResponse {
        if !(200...299 ~= httpURLResponse.statusCode) {
          var error = SunlightRestClient.RestError(
            errorCode: httpURLResponse.statusCode
          )

          if let json = try? JSONSerialization.jsonObject(
            with: data,
            options: []
          ) {
            error.jsonPayload = json
          }

          throw error
        }
      }

      return data
    }
    .mapError { error -> SunlightRestClient.RestError in
      return SunlightRestClient.RestError(error: error)
    }
    .eraseToAnyPublisher()
  }
}
