import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public func send(_ req: HttpRequest) async throws -> HttpResponse {
  var request = URLRequest(url: req.url)
  request.httpMethod = req.method.rawValue
  request.httpBody = req.body

  for (key, value) in req.headers.toDictionary() {
    request.setValue(value, forHTTPHeaderField: key)
  }

  let delegate = SessionDelegate(
    allowInsecure: req.unauthorizedTLS,
    redirection: req.redirection
  )

  let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)

  let (data, response) = try await session.data(for: request)

  guard let response = response as? HTTPURLResponse else {
    throw URLError(.badServerResponse)
  }

  var headers: [String: String] = [:]
  for (key, value) in response.allHeaderFields {
    if let key = key as? String, let value = value as? String {
      headers[key] = value
    }
  }

  return HttpResponse(
    url: response.url ?? req.url,
    status: response.statusCode,
    headers: HeaderMap(headers: headers),
    bodyData: data
  )
}
