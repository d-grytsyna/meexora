import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewModel()
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ZStack {
            StyleGuide.Colors.primaryBackground.ignoresSafeArea()
            
            VStack(spacing: StyleGuide.Spacing.medium) {
                Text("Reset your password")
                    .font(StyleGuide.Fonts.title)
                    .foregroundColor(StyleGuide.Colors.primaryText)
                
                VStack(spacing: StyleGuide.Spacing.medium) {
                    currentStepView
                    
                    if let error = viewModel.error {
                        Text(error)
                            .font(StyleGuide.Fonts.small)
                            .foregroundColor(StyleGuide.Colors.errorText)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    Task { await handleNextAction() }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: StyleGuide.Colors.buttonText))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(StyleGuide.Colors.buttonSecondaryBackground)
                            .cornerRadius(StyleGuide.Corners.medium)
                            .shadow(color: StyleGuide.Shadows.color, radius: StyleGuide.Shadows.radius, x: StyleGuide.Shadows.x, y: StyleGuide.Shadows.y)
                    } else {
                        Text(viewModel.buttonTitle)
                            .modifier(StyleGuide.Buttons.accent())
                    }
                }
                .disabled(viewModel.isLoading)
                .padding(.horizontal)
                
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var currentStepView: some View {
        switch viewModel.currentStep {
        case .enterEmail:
            CustomTextField(placeholder: "Email", text: $viewModel.email, isSecure: false)
            Text("Enter your account email and we’ll send you a verification code to reset your password.")
                .font(StyleGuide.Fonts.small)
                .foregroundColor(StyleGuide.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        case .enterVerificationCode:
            VStack(spacing: StyleGuide.Spacing.large) {
                VStack(spacing: StyleGuide.Spacing.small) {
                    Text("Check your email")
                        .font(StyleGuide.Fonts.title)
                        .foregroundColor(StyleGuide.Colors.primaryText)
                    
                    Text("We’ve sent a verification code to your email. Enter the code and create a new password to reset your account.")
                        .font(StyleGuide.Fonts.small)
                        .foregroundColor(StyleGuide.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                LimitedTextField(
                    placeholder: "Verification Code",
                    text: $viewModel.verificationCode,
                    limit: 6,
                    isSecure: false,
                    keyboard: .numberPad
                )
                CustomTextField(placeholder: "New Password", text: $viewModel.newPassword, isSecure: true)
                
                if viewModel.isResendAvailable {
                    Button(action: {
                        Task { await viewModel.resendCode() }
                    }) {
                        if viewModel.isLoadingReset {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: StyleGuide.Colors.accentPurple))
                        } else {
                            Text("Resend Code")
                                .font(StyleGuide.Fonts.bodyBold)
                                .foregroundColor(StyleGuide.Colors.accentPurple)
                        }
                    }
                    .disabled(viewModel.isLoadingReset)
                } else {
                    Text("You can resend the code in \(viewModel.resendAvailableIn) seconds")
                        .font(StyleGuide.Fonts.small)
                        .foregroundColor(StyleGuide.Colors.secondaryText)
                }
            }
        }
    }
    
    private func handleNextAction() async {
        switch viewModel.currentStep {
        case .enterEmail:
            await viewModel.submitEmail()
        case .enterVerificationCode:
            await viewModel.submitVerification(authManager: authManager)
        }
    }
}
#Preview {
    ForgotPasswordView()
        .environmentObject(AuthManager())
}
