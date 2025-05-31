import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: T
}
