import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

final class SessionDelegate: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
  let allowInsecure: Bool
  let redirection: HttpRequest.Redirection

  init(allowInsecure: Bool, redirection: HttpRequest.Redirection) {
    self.allowInsecure = allowInsecure
    self.redirection = redirection
  }

  func urlSession(
    _ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
  ) {
    if allowInsecure
      && challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
    {
      if let trust = challenge.protectionSpace.serverTrust {
        completionHandler(.useCredential, URLCredential(trust: trust))
        return
      }
    }

    completionHandler(.performDefaultHandling, nil)
  }

  func urlSession(
    _ session: URLSession, task: URLSessionTask,
    willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest,
    completionHandler: @escaping (URLRequest?) -> Void
  ) {
    switch redirection {
    case .follow:
      completionHandler(request)
    case .manual:
      completionHandler(nil)
    }
  }
}
