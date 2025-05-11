
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
                .padding()

            Spacer()

            if viewModel.isLoggingOut {
                ProgressView()
                    .padding()
            } else {
                Button(action: {
                    Task {
                        await viewModel.logout(using: authManager)
                    }
                }) {if viewModel.isLoggingOut {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: StyleGuide.Colors.buttonText))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(StyleGuide.Colors.buttonPrimaryBackground)
                        .cornerRadius(StyleGuide.Corners.medium)
                        .shadow(color: StyleGuide.Shadows.color, radius: StyleGuide.Shadows.radius, x: StyleGuide.Shadows.x, y: StyleGuide.Shadows.y)
                } else {
                    Text("Log out")
                        .modifier(StyleGuide.Buttons.primary())
                }
                }.disabled(viewModel.isLoggingOut)
                .padding(.horizontal)
            }
        }
    }
}
