import SwiftUI

struct RegistrationEnterVerificationCodeView: View {
    @ObservedObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack(spacing: StyleGuide.Spacing.medium) {
            VStack(spacing: StyleGuide.Spacing.small) {
                Text("Enter your verification code")
                    .font(StyleGuide.Fonts.title)
                    .foregroundColor(StyleGuide.Colors.primaryText)
                
                Text("We've sent a code to your email. Please enter it to continue.")
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
            if viewModel.isResendAvailable {
                Button(action: {
                    Task {
                        await viewModel.resendCode()
                    }
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
                .font(StyleGuide.Fonts.bodyBold)
                .foregroundColor(StyleGuide.Colors.accentPurple)
            } else {
                Text("You can resend the code in \(viewModel.resendAvailableIn) seconds")
                    .font(StyleGuide.Fonts.small)
                    .foregroundColor(StyleGuide.Colors.secondaryText)
            }
        }
    }
}

#Preview {
    RegistrationEnterVerificationCodeView(viewModel: RegistrationViewModel())
}
