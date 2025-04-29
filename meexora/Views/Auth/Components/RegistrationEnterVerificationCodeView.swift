import SwiftUI

struct RegistrationEnterVerificationCodeView: View {
    @ObservedObject var viewModel: RegistrationViewModel
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        VStack(spacing: StyleGuide.Spacing.large) {
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
            
            CustomTextField(placeholder: "Verification Code", text: $viewModel.verificationCode, isSecure: false)
                .padding(.horizontal)
        }
    }
}

