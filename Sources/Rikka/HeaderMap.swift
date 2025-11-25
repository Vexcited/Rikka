public class HeaderMap {
  private var headers: [String: String]

  public init(headers: [String: String] = [:]) {
    self.headers = headers
  }

  public func get(_ key: String) -> String? {
    let key = key.lowercased()

    for (k, v) in headers {
      if k.lowercased() == key {
        return v
      }
    }

    return nil
  }

  public func set(_ key: String, _ value: String) {
    let key = key.lowercased()

    for k in headers.keys {
      if k.lowercased() == key {
        headers[k] = value
        return
      }
    }

    headers[key] = value
  }

  public func getSetCookie() -> [String] {
    guard let setCookieHeader = get(HeaderKeys.setCookie) else {
      return []
    }

    return splitSetCookieValue(setCookieHeader)
  }

  public func toDictionary() -> [String: String] {
    return headers
  }

  private func splitSetCookieValue(_ headerValue: String) -> [String] {
    var output: [String] = []
    let chars = Array(headerValue)
    var index = 0

    func skipWhitespace() -> Bool {
      while index < chars.count && chars[index].isWhitespace {
        index += 1
      }
      return index < chars.count
    }

    func notSpecialChar() -> Bool {
      let c = chars[index]
      return c != "=" && c != ";" && c != ","
    }

    while index < chars.count {
      var start = index
      var cookiesSeparatorFound = false

      while skipWhitespace() {
        let character = chars[index]

        if character == "," {
          let lastComma = index
          index += 1

          _ = skipWhitespace()
          let nextStart = index

          while index < chars.count && notSpecialChar() {
            index += 1
          }

          if index < chars.count && chars[index] == "=" {
            cookiesSeparatorFound = true
            index = nextStart
            output.append(String(chars[start..<lastComma]))
            start = index
          } else {
            index = lastComma + 1
          }
        } else {
          index += 1
        }
      }

      if !cookiesSeparatorFound || index >= chars.count {
        if start < chars.count {
          output.append(String(chars[start..<chars.count]))
        }
        index = chars.count
      }
    }

    return output
  }
}
