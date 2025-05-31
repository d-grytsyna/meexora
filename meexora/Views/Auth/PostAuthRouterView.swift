import SwiftUI

struct PostAuthRouterView: View {
    @State private var isLoading = true
    @State private var hasProfile = false
    @State private var error: String?
    @AppStorage("userCity") private var cachedCity: String = ""
    

    var body: some View {
        content
            .task {
                await loadProfile()
            }
    }

    @ViewBuilder
    private var content: some View {
        if isLoading {
            ProgressView("Loading...")
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
            let profile = try await UserService.getProfile()
            cachedCity = profile.location
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

