import Foundation

@MainActor
final class RegistrationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var role: String = ""
    @Published var verificationCode: String = ""
    
    @Published var currentStep: RegistrationStep = .enterEmail
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    var buttonTitle: String {
        switch currentStep {
        case .enterEmail: return "Next"
        case .selectRole: return "Next"
        case .enterVerificationCode: return "Confirm"
        case .completed: return ""
        }
    }
    
    func submitEmail() async {
        isLoading = true
        error = nil
        
        let validationResult = RegistrationValidator.validate(email: email, password: password)
        
        if validationResult.isFailure {
            self.error = validationResult.errorMessages.first
            self.isLoading = false
            return
        }
        
        do {
            try await AuthService.requestRegistration(email: email)
            DispatchQueue.main.async {
                self.currentStep = .selectRole
            }
        } catch {
            self.error = "Failed to request registration: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func selectRole(_ selectedRole: String) {
        self.role = selectedRole
        self.currentStep = .enterVerificationCode
    }
    
    func submitVerification(authManager: AuthManager) async {
        isLoading = true
        error = nil
        
        do {
            let response = try await AuthService.confirmRegistration(
                email: email,
                password: password,
                role: role,
                code: verificationCode
            )
            
            TokenStorage.saveAccessToken(response.accessToken)
            TokenStorage.saveRefreshToken(response.refreshToken)
            
            authManager.loginSuccess()
        } catch {
            self.error = "Failed to confirm registration: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

enum RegistrationStep {
    case enterEmail
    case selectRole
    case enterVerificationCode
    case completed
}
