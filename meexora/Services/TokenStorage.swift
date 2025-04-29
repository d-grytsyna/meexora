import Foundation

struct TokenStorage {
    static func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "access_token")
    }

    static func saveRefreshToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "refresh_token")
    }

    static func getAccessToken() -> String? {
        UserDefaults.standard.string(forKey: "access_token")
    }

    static func getRefreshToken() -> String? {
        UserDefaults.standard.string(forKey: "refresh_token")
    }

    static func clearTokens() {
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "refresh_token")
    }
}
