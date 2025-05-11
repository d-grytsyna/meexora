import Foundation

struct RequestBuilder {

    static func buildRequest(
        path: String,
        method: String = "GET",
        body: Encodable? = nil,
        queryItems: [URLQueryItem]? = nil,
        headers: [String: String] = ["Content-Type": "application/json"]
    ) throws -> URLRequest {
        
        var components = URLComponents(string: "\(Constants.apiBaseURL)\(path)")
        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method

        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
        }

        return request
    }
}
