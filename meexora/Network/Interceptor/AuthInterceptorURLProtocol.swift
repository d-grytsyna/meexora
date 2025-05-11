import Foundation

class AuthInterceptorURLProtocol: URLProtocol {
    private var authSession: URLSession?
    private var authTask: URLSessionDataTask?

    override class func canInit(with request: URLRequest) -> Bool {
        guard URLProtocol.property(forKey: "Handled", in: request) == nil else { return false }
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        let request = self.request
        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return
        }


        URLProtocol.setProperty(true, forKey: "Handled", in: mutableRequest)

        if let token = TokenStorage.getAccessToken() {
            mutableRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let config = URLSessionConfiguration.default
        authSession = URLSession(configuration: config, delegate: nil, delegateQueue: nil)

        authTask = authSession?.dataTask(with: mutableRequest as URLRequest) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                self.handleUnauthorized(originalRequest: request)
                return
            }

            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            if let response = response {
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            } else {
                self.client?.urlProtocolDidFinishLoading(self)
            }
        }
        authTask?.resume()
    }

    override func stopLoading() {
        authTask?.cancel()
    }

    private func handleUnauthorized(originalRequest: URLRequest) {
            Task {
                do {
                    let newTokens = try await AuthService.refreshToken()
                    TokenStorage.saveAccessToken(newTokens.accessToken)
                    TokenStorage.saveRefreshToken(newTokens.refreshToken)

                    var retriedRequest = originalRequest
                    retriedRequest.setValue("Bearer \(newTokens.accessToken)", forHTTPHeaderField: "Authorization")

                    guard let mutableRequest = (retriedRequest as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
                        return
                    }

                    URLProtocol.setProperty(true, forKey: "Handled", in: mutableRequest)

                    let (data, response) = try await URLSession.shared.data(for: mutableRequest as URLRequest)
                    if let httpResponse = response as? HTTPURLResponse {
                        self.client?.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy: .notAllowed)
                    }
                    self.client?.urlProtocol(self, didLoad: data)
                    self.client?.urlProtocolDidFinishLoading(self)

                } catch {
                    DispatchQueue.main.async {
                        AuthManager.shared.logoutWithSessionExpired()
                    }
                    self.client?.urlProtocol(self, didFailWithError: error)
                }
            }
        }
}
