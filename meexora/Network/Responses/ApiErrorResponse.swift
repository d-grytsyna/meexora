import Foundation

struct ApiErrorResponse: Codable {
    let timestamp: String
    let status: Int
    let error: String
    let message: String
}
