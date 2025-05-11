import SwiftUI

struct PostAuthRouterView: View {
    @State private var isLoading = true
    @State private var hasProfile = false
    @State private var error: String?

    var body: some View {
        content
            .task {
                await loadProfile()
            }
    }

    @ViewBuilder
    private var content: some View {
        if isLoading {
            ProgressView("Loading profile...")
        } else if let error = error {
            VStack(spacing: 16) {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                Button("Retry") {
                    Task {
                        await loadProfile()
                    }
                }
            }
            .padding()
        } else if hasProfile {
            MainTabView()
        } else {
            CompleteProfileView()
        }
    }

    private func loadProfile() async {
        do {
            _ = try await UserService.getProfile()
            hasProfile = true
        } catch {
            let nsError = error as NSError
            if nsError.domain == "APIError", nsError.code == 404 {
                hasProfile = false
            } else {
                self.error = nsError.localizedDescription
            }
        }
        isLoading = false
    }

}

#Preview {
    PostAuthRouterView()
}

