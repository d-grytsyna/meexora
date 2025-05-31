import Foundation

final class APIClient {
    static let shared = APIClient()

    let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [AuthInterceptorURLProtocol.self] + (config.protocolClasses ?? [])
        self.session = URLSession(configuration: config)
    }

    func send<T: Decodable>(_ request: URLRequest, responseType: T.Type) async throws -> T {
        let (data, response) = try await session.data(for: request)

        if let error = NetworkErrorHandler.handle(response: response, data: data) {
            throw error
        }

        let raw = String(data: data, encoding: .utf8)
        print("Raw JSON response:\n\(raw ?? "nil")")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let apiResponse = try decoder.decode(ApiResponse<T>.self, from: data)
            return apiResponse.data
        } catch let decodingError as DecodingError {
            print("Decoding error:")
            switch decodingError {
            case .typeMismatch(let type, let context):
                print("Type mismatch: \(type) – \(context.debugDescription), codingPath: \(context.codingPath)")
            case .valueNotFound(let type, let context):
                print("Value not found: \(type) – \(context.debugDescription), codingPath: \(context.codingPath)")
            case .keyNotFound(let key, let context):
                print("Key not found: \(key) – \(context.debugDescription), codingPath: \(context.codingPath)")
            case .dataCorrupted(let context):
                print("Data corrupted – \(context.debugDescription), codingPath: \(context.codingPath)")
            @unknown default:
                print("Unknown decoding error")
            }
            throw decodingError
        } catch {
            print("Unexpected error: \(error)")
            throw error
        }
    }

    
    func sendVoid(_ request: URLRequest) async throws {
            let (data, response) = try await session.data(for: request)
            if let error = NetworkErrorHandler.handle(response: response, data: data) { throw error }
        }
}
