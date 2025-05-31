
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("Profile")
                .font(.largeTitle)
                .padding(.top)
            VStack {
                Text("User info to display")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .padding()

            Spacer()

            if viewModel.isLoggingOut {
                ProgressView()
                    .padding(.bottom)
            } else {
                Button(action: {
                    Task {
                        await viewModel.logout(using: authManager)
                    }
                }) {
                    Text("Log out")
                        .modifier(StyleGuide.Buttons.primary())
                }
                .disabled(viewModel.isLoggingOut)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .padding()
    }
}
