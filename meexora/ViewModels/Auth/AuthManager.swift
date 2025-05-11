import SwiftUI

@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()
    @Published var isLoggedIn: Bool = false
    @Published var sessionExpired: Bool = false
    @Published var userRole: String? = nil

    init() {
        if let token = TokenStorage.getAccessToken() {
               isLoggedIn = true
               decodeToken(token) 
           } else {
               isLoggedIn = false
           }
        }

    func loginSuccess(accessToken: String, refreshToken: String) {
            TokenStorage.saveAccessToken(accessToken)
            TokenStorage.saveRefreshToken(refreshToken)
            decodeToken(accessToken)
            sessionExpired = false
            isLoggedIn = true
    }


    func logout() {
        isLoggedIn = false
        TokenStorage.clearTokens()
    }
    
    func logoutWithSessionExpired() {
        sessionExpired = true
        logout()
    }
    func decodeToken(_ token: String) {
           let segments = token.components(separatedBy: ".")
           guard segments.count == 3 else { return }

           let payload = segments[1]
           var paddedPayload = payload
           while paddedPayload.count % 4 != 0 {
               paddedPayload += "="
           }

           guard let data = Data(base64Encoded: paddedPayload),
                 let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                 let role = json["role"] as? String else {
               return
           }

           userRole = role
           isLoggedIn = true
           
       }
}
