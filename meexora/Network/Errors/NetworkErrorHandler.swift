import Foundation

struct NetworkErrorHandler {

    static func handle(response: URLResponse?, data: Data?) -> Error? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return URLError(.badServerResponse)
        }
        if (200..<300).contains(httpResponse.statusCode) {
            return nil
        }

        if let data = data,
           let errorResponse = try? JSONDecoder().decode(ApiErrorResponse.self, from: data) {
            return NSError(
                domain: "APIError",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: errorResponse.message]
            )
        }

        return NSError(
            domain: "APIError",
            code: httpResponse.statusCode,
            userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)]
        )
    }
}
