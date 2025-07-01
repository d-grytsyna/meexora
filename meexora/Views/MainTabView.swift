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
        
            
            BookingListView()
                .tabItem {
                    Image(systemName: "ticket")
                    Text("Bookings")
                }
            
            if authManager.userRole == "ORGANIZER" {
                ManagementView()
                        .tabItem {
                            Image(systemName: "list.bullet.rectangle")
                            Text("Management")
                        }
            }
            ProfileView(authManager: authManager)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    MainTabView()
}
