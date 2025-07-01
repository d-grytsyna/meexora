import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var isLoggingOut = false
    @Published var isLoading: Bool = false

    private let authManager: AuthManager
    @Published var user: UserProfileDto
    @Published var error: String?
    init(authManager: AuthManager) {
            self.authManager = authManager
            self.user = UserProfileDto(firstName: "", lastName: "", birthdate: "", location: "")
    }
    func fetchUserProfile() async {
        isLoading = true
        defer { isLoading = false }

        do {
            user = try await UserService.getProfile()
        } catch {
            self.error = "Failed to fetch user profile: \(error.localizedDescription)"
        }
    }
    var formattedBirthdate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = formatter.date(from: user.birthdate) else { return "—" }

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .long

        return displayFormatter.string(from: date)
    }


        func logout() async {
            isLoggingOut = true
            do {
                authManager.logout()
                try await AuthService.logout()
            } catch {
                authManager.logout()
                self.error = "Logout failed: \(error.localizedDescription)"
            }
            isLoggingOut = false
        }
}
