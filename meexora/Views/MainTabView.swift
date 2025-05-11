import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authManager: AuthManager
    var body: some View {
        TabView {
            EventUserListView()
                            .tabItem {
                                Image(systemName: "calendar")
                                Text("Events")
                            }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
            
            Text("Settings")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            if authManager.userRole == "ORGANIZER" {
                ManagementView()
                        .tabItem {
                            Image(systemName: "list.bullet.rectangle")
                            Text("Management")
                        }
            }
        }
    }
}

#Preview {
    MainTabView()
}
