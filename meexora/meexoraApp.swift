import SwiftUI

@main
struct meexoraApp: App {
    @StateObject var authManager = AuthManager()

    var body: some Scene {
        WindowGroup {
            if authManager.isLoggedIn {
                Text("Welcome to Meexora!")
            } else {
                LoginView()
                    .environmentObject(authManager)
            }
        }
    }
}
