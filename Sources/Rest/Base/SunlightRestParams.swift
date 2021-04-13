import Combine
import Foundation

public extension SunlightRestClient {
  typealias RestParams = [String: CustomStringConvertible]
}

extension SunlightRestClient.RestParams: SunlightRestHttpBodyConvertible {
  public func buildHttpBodyPart(boundary: String) -> Data {
    let httpBody = NSMutableData()

    forEach { (name, value) in
      httpBody.appendString("--\(boundary)\r\n")
      httpBody.appendString(
        "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
      )
      httpBody.appendString(value.description)
      httpBody.appendString("\r\n")
    }

    return httpBody as Data
  }
}

fileprivate extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
