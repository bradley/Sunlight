import Combine
import Foundation

public protocol SunlightRestJsonDecodable {
  // The method you declare your JSON mapping in.
  static func decode(_ json: Any) throws -> Self
}

// Provide default implementation for Decodable models.
public extension SunlightRestJsonDecodable where Self: Decodable {
  static func decode(_ json: Any) throws -> Self {
    let decoder = JSONDecoder()
    let data = try JSONSerialization.data(withJSONObject: json, options: [])
    let model = try decoder.decode(Self.self, from: data)
    return model
  }
}
