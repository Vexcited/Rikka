import Foundation

public struct HttpRequest {
  public let url: URL
  public let method: HttpRequestMethod
  public let body: Data?
  public let headers: HeaderMap
  public let redirection: HttpRequestRedirection
  public let unauthorizedTLS: Bool

  public typealias Builder = HttpRequestBuilder
  public typealias Method = HttpRequestMethod
  public typealias Redirection = HttpRequestRedirection
}
