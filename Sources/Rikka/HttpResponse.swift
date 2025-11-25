import Foundation
import SwiftSoup

public class HttpResponse {
  public let url: URL
  public let status: Int
  public let headers: HeaderMap
  private let bodyData: Data

  public init(url: URL, status: Int, headers: HeaderMap, bodyData: Data) {
    self.url = url
    self.status = status
    self.headers = headers
    self.bodyData = bodyData
  }

  public func toString() -> String {
    return String(data: bodyData, encoding: .utf8) ?? ""
  }

  public func toData() -> Data {
    return bodyData
  }

  public func toHTML() throws -> Document {
    return try SwiftSoup.parse(toString())
  }

  public func toJSON<T: Decodable>() throws -> T {
    return try JSONDecoder().decode(T.self, from: bodyData)
  }
}
