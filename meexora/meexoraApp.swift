import SwiftUI
import Stripe

@main
struct meexoraApp: App {
    @StateObject var authManager = AuthManager()
    @StateObject var deepLinkManager = DeepLinkManager()

    init() {
           StripeAPI.defaultPublishableKey = "pk_test_51RMCFxC6bH50redfyvGMobfeb48oESkfsNNjC48cdxAprCTl5wtCacqR6nXd0gh1sWqpDGRogGbEhnvN9m5AIp8G00ycSpsbAM"
       }

    var body: some Scene {
        WindowGroup {
            AppEntryView()
                .environmentObject(authManager)
                .environmentObject(deepLinkManager)
                .onOpenURL { url in
                    deepLinkManager.handle(url: url)
                }
        }
    }
}
