import Foundation

@MainActor
final class RegistrationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var role: String = ""
    @Published var verificationCode: String = ""
    
    @Published var currentStep: RegistrationStep = .enterEmail
    @Published var isLoading: Bool = false
    @Published var isLoadingReset: Bool = false
    
    @Published var error: String?
    @Published var resendAvailableIn: Int = 60
    @Published var isResendAvailable: Bool = false

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


    var buttonTitle: String {
        switch currentStep {
        case .enterEmail: return "Next"
        case .selectRole: return "Next"
        case .enterVerificationCode: return "Confirm"
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
            self.startResendTimer()
            self.currentStep = .selectRole
            
        } catch {
            self.error = "Failed to request registration: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func resendCode() async{
        error = nil
        isLoadingReset = true
        do {
            try await AuthService.requestRegistration(email: email)
            self.startResendTimer()
            
        } catch {
            self.error = "Failed to request code: \(error.localizedDescription)"
        }
        isLoadingReset = false

    }
    
    func selectRole(_ selectedRole: String) {
        self.role = selectedRole
        self.currentStep = .enterVerificationCode
    }
    
    func submitVerification(authManager: AuthManager) async {
        isLoading = true
        error = nil
        
        let validationResult = VerificationValidator.validate(code: verificationCode)
        
        if validationResult.isFailure {
            self.error = validationResult.errorMessages.first
            self.isLoading = false
            return
        }
        
        do {
            let response = try await AuthService.confirmRegistration(
                email: email,
                password: password,
                role: role,
                code: verificationCode
            )
            
            authManager.loginSuccess(accessToken: response.accessToken, refreshToken: response.refreshToken)
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
}
