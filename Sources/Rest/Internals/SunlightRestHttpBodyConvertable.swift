import Combine
import Foundation

public protocol SunlightRestHttpBodyConvertible {
  func buildHttpBodyPart(boundary: String) -> Data
}
