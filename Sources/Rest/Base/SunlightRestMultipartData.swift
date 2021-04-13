import Combine
import Foundation

public extension SunlightRestClient {
  struct RestMultipartData {
    let name: String
    let fileData: Data
    let fileName: String
    let mimeType: String

    public init(
      name: String,
      fileData: Data,
      fileName: String,
      mimeType: String
    ) {
      self.name = name
      self.fileData = fileData
      self.fileName = fileName
      self.mimeType = mimeType
    }
  }
}

extension SunlightRestClient.RestMultipartData:
  SunlightRestHttpBodyConvertible {
  public func buildHttpBodyPart(boundary: String) -> Data {
    let httpBody = NSMutableData()

    httpBody.appendString("--\(boundary)\r\n")
    httpBody.appendString(
      "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n"
    )
    httpBody.appendString("Content-Type: \(mimeType)\r\n\r\n")
    httpBody.append(fileData)
    httpBody.appendString("\r\n")

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
