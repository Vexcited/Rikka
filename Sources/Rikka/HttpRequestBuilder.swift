import Foundation

public class HttpRequestBuilder {
  private var body: Data?
  private var cookies: [String: String] = [:]
  private var headers = HeaderMap()
  private var method: HttpRequestMethod = .get
  private var redirection: HttpRequestRedirection = .manual
  private var unauthorizedTLS = false
  private var urlComponents: URLComponents

  public convenience init(_ url: String) throws {
    guard let u = URL(string: url)
    else {
      throw URLError(.badURL)
    }

    try self.init(u)
  }

  public init(_ url: URL) throws {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
      throw URLError(.badURL)
    }

    self.urlComponents = components
  }

  public func appendUrlSearchParameter(_ key: String, _ value: String) -> Self {
    var queryItems = urlComponents.queryItems ?? []
    queryItems.append(URLQueryItem(name: key, value: value))
    urlComponents.queryItems = queryItems
    return self
  }

  public func build() throws -> HttpRequest {
    let cookieString = cookies.map { "\($0.key)=\($0.value)" }.joined(separator: "; ")
    if !cookieString.isEmpty {
      headers.set(HeaderKeys.cookie, cookieString)
    }

    guard let url = urlComponents.url else {
      throw URLError(.badURL)
    }

    return HttpRequest(
      url: url,
      method: method,
      body: body,
      headers: headers,
      redirection: redirection,
      unauthorizedTLS: unauthorizedTLS
    )
  }

  public func deleteAllCookies() -> Self {
    cookies = [:]
    return self
  }

  public func deleteCookie(_ key: String) -> Self {
    cookies.removeValue(forKey: key)
    return self
  }

  public func deleteUrlSearchParameter(_ key: String) -> Self {
    if var queryItems = urlComponents.queryItems {
      queryItems.removeAll { $0.name == key }
      urlComponents.queryItems = queryItems
    }
    return self
  }

  public func enableUnauthorizedTLS() -> Self {
    unauthorizedTLS = true
    return self
  }

  public func setAllCookies(_ cookies: [(String, String)]) -> Self {
    var newCookies: [String: String] = [:]
    for (key, value) in cookies {
      newCookies[key] = value
    }
    self.cookies.merge(newCookies) { (_, new) in new }
    return self
  }

  public func setAllCookies(_ cookies: [String]) -> Self {
    var newCookies: [String: String] = [:]
    for cookie in cookies {
      let parts = cookie.split(separator: "=", maxSplits: 1).map(String.init)
      if parts.count == 2 {
        newCookies[parts[0]] = parts[1]
      }
    }
    self.cookies.merge(newCookies) { (_, new) in new }
    return self
  }

  public func setAllCookies(_ cookies: [String: String]) -> Self {
    self.cookies.merge(cookies) { (_, new) in new }
    return self
  }

  public func setCookie(_ key: String, _ value: String) -> Self {
    cookies[key] = value
    return self
  }

  public func setFormUrlEncodedBody(_ searchParams: [String: String]) -> Self {
    var components = URLComponents()
    components.queryItems = searchParams.map { URLQueryItem(name: $0.key, value: $0.value) }
    if let query = components.query {
      self.body = query.data(using: .utf8)
      self.headers.set(HeaderKeys.contentType, "application/x-www-form-urlencoded")
    }
    return self
  }

  public func setHeader(_ key: String, _ value: String) -> Self {
    headers.set(key, value)
    return self
  }

  public func setJsonBody(_ json: Any) -> Self {
    if let data = try? JSONSerialization.data(withJSONObject: json, options: []) {
      self.body = data
      self.headers.set(HeaderKeys.contentType, "application/json")
    }
    return self
  }

  public func setMethod(_ method: HttpRequestMethod) -> Self {
    self.method = method
    return self
  }

  public func setRedirection(_ redirect: HttpRequestRedirection) -> Self {
    self.redirection = redirect
    return self
  }

  public func setUrlSearchParameter(_ key: String, _ value: String) -> Self {
    var queryItems = urlComponents.queryItems ?? []
    if let index = queryItems.firstIndex(where: { $0.name == key }) {
      queryItems[index] = URLQueryItem(name: key, value: value)
    } else {
      queryItems.append(URLQueryItem(name: key, value: value))
    }
    urlComponents.queryItems = queryItems
    return self
  }
}
