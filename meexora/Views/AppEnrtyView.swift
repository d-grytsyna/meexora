import SwiftUI

struct AppEntryView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        Group {
            if authManager.isLoggedIn {
                PostAuthRouterView()
            } else {
                LoginView()
            }
        }
        .alert("Session expired", isPresented: $authManager.sessionExpired) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please log in again to continue.")
        }
    }
}

