import SwiftUI

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        ZStack {
            StyleGuide.Colors.primaryBackground.ignoresSafeArea()

            VStack(spacing: StyleGuide.Spacing.large) {
                Text("Create your account")
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

                if viewModel.currentStep != .completed && viewModel.currentStep != .selectRole{
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
            }
            .padding()
        }
    }

    @ViewBuilder
    private var currentStepView: some View {
        switch viewModel.currentStep {
        case .enterEmail:
            RegistrationEnterEmailView(viewModel: viewModel)
        case .selectRole:
            RegistrationSelectRoleView(viewModel: viewModel)
        case .enterVerificationCode:
            RegistrationEnterVerificationCodeView(viewModel: viewModel)
        case .completed:
            Text("Registration Completed Successfully!")
                .font(StyleGuide.Fonts.title)
                .foregroundColor(StyleGuide.Colors.whiteText)
        }
    }

    private func handleNextAction() async {
        switch viewModel.currentStep {
        case .enterEmail:
            await viewModel.submitEmail()
        case .enterVerificationCode:
            await viewModel.submitVerification(authManager: authManager)
        case .completed, .selectRole:
            break
        }
    }
}

#Preview {
    RegistrationView()
        .environmentObject(AuthManager())
}
