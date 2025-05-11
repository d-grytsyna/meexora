import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var isLoggingOut = false
    @Published var error: String?
    
    func logout(using authManager: AuthManager) async {
        isLoggingOut = true
        do {
            try await AuthService.logout()
            authManager.logout()
        } catch {
            self.error = "Logout failed: \(error.localizedDescription)"
        }
        isLoggingOut = false
    }
}
