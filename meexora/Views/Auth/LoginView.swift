import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                StyleGuide.Gradients.background
                    .ignoresSafeArea()
                
                VStack(spacing: StyleGuide.Spacing.large) {
                    VStack(spacing: StyleGuide.Spacing.small) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                        
                        Text("Welcome to Meexora")
                            .font(StyleGuide.Fonts.largeTitle)
                            .foregroundColor(StyleGuide.Colors.whiteText)
                            .multilineTextAlignment(.center)
                        
                        Text("Discover and create unforgettable events")
                            .font(StyleGuide.Fonts.bodyBold)
                            .foregroundColor(StyleGuide.Colors.whiteText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    VStack(spacing: StyleGuide.Spacing.medium) {
                        CustomTextField(placeholder: "Email", text: $viewModel.email, isSecure: false)
                        CustomTextField(placeholder: "Password", text: $viewModel.password, isSecure: true)
                        if let error = viewModel.error {
                            Text(error)
                                .font(StyleGuide.Fonts.small)
                                .foregroundColor(StyleGuide.Colors.errorText)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        Task {
                            await viewModel.login(authManager: authManager)
                        }
                    }) {if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: StyleGuide.Colors.buttonText))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(StyleGuide.Colors.buttonPrimaryBackground)
                            .cornerRadius(StyleGuide.Corners.medium)
                            .shadow(color: StyleGuide.Shadows.color, radius: StyleGuide.Shadows.radius, x: StyleGuide.Shadows.x, y: StyleGuide.Shadows.y)
                    } else {
                        Text("Log In")
                            .modifier(StyleGuide.Buttons.primary())
                    }
                        
                        
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.horizontal)
                    
                    HStack {
                            NavigationLink(destination: ForgotPasswordView()) {
                                Text("Forgot Password?")
                                    .font(StyleGuide.Fonts.small)
                                    .foregroundColor(StyleGuide.Colors.primaryText)
                                    .underline()
                            }
                    }
                }
                .padding()
            }
            
            NavigationLink(destination: RegistrationView().environmentObject(authManager)) {
                                    Text("Don't have an account?")
                                        .font(StyleGuide.Fonts.small)
                                        .foregroundColor(StyleGuide.Colors.primaryText)
                                    Text("Register")
                    .font(StyleGuide.Fonts.small)
                    .foregroundColor(StyleGuide.Colors.accentPurple)
                    .underline()
                                }
                                .padding(.top)
        }.tint(StyleGuide.Colors.accentPurple)
    }
}



#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
