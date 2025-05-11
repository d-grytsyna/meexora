import Foundation

@MainActor
final class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var newPassword: String = ""
    @Published var verificationCode: String = ""
    
    @Published var currentStep: ForgotPasswordStep = .enterEmail
    @Published var isLoading: Bool = false
    @Published var isLoadingReset: Bool = false
    @Published var error: String?
    
    @Published var resendAvailableIn: Int = 60
    @Published var isResendAvailable: Bool = false
    
    var buttonTitle: String {
        switch currentStep {
        case .enterEmail: return "Next"
        case .enterVerificationCode: return "Confirm"
        }
    }
    
    private var timer: Timer?

    func startResendTimer() {
        resendAvailableIn = 60
        isResendAvailable = false

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }

            Task { @MainActor in
                if self.resendAvailableIn > 0 {
                    self.resendAvailableIn -= 1
                } else {
                    self.isResendAvailable = true
                    self.timer?.invalidate()
                }
            }
        }
    }

    func resendCode() async{
        error = nil
        isLoadingReset = true;
        do {
            try await AuthService.requestPasswordReset(email: email)
            self.startResendTimer()
            
        } catch {
            self.error = "Failed to request code: \(error.localizedDescription)"
        }
        isLoadingReset = false;

    }
    
    
    func submitEmail() async {
        isLoading = true
        error = nil
        
        let validationResult = EmailValidator.validate(email: email)
        
        if validationResult.isFailure {
            self.error = validationResult.errorMessages.first
            self.isLoading = false
            return
        }
        
        do {
            try await AuthService.requestPasswordReset(email: email)
            self.startResendTimer()
            self.currentStep = .enterVerificationCode
            
        } catch {
            self.error = "Failed to request password reset: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func submitVerification(authManager: AuthManager) async {
        isLoading = true
        error = nil
        
        let validationResult = ResetPasswordValidator.validate(code: verificationCode, password: newPassword)
        
        if validationResult.isFailure {
            self.error = validationResult.errorMessages.first
            self.isLoading = false
            return
        }
        
        do {
            let response = try await AuthService.confirmPasswordReset(
                email: email,
                newPassword: newPassword,
                code: verificationCode
            )
            

            
            authManager.loginSuccess(accessToken: response.accessToken, refreshToken: response.refreshToken)
        } catch {
            self.error = "Failed to confirm password reset: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

enum ForgotPasswordStep {
    case enterEmail
    case enterVerificationCode
}
