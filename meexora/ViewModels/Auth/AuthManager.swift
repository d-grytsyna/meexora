import SwiftUI

final class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false

    func loginSuccess() {
        isLoggedIn = true
    }

    func logout() {
        isLoggedIn = false
        TokenStorage.clearTokens()
    }
}
