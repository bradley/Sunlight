import Combine
import Foundation

public extension SunlightRestClient {
  enum RestHttpVerb: String {
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case post = "POST"
    case delete = "DELETE"
  }
}
