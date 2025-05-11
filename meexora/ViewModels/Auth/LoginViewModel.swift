import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    func login(authManager: AuthManager) async {
        isLoading = true
        error = nil
        
        let validationResult = LoginValidator.validate(email: email, password: password)
        
        if validationResult.isFailure {
            self.error = validationResult.errorMessages.first
            self.isLoading = false
            return
        }
        
        do {
            let response = try await AuthService.login(email: email, password: password)
            authManager.loginSuccess(accessToken: response.accessToken, refreshToken: response.refreshToken)
        } catch {
            self.error = "Login failed: \(error.localizedDescription)"
        }
        
        self.isLoading = false
    }
}
