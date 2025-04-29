import Foundation

struct RequestBuilder {

    static func buildRequest(
        path: String,
        method: String = "GET",
        body: Encodable? = nil,
        headers: [String: String] = ["Content-Type": "application/json"]
    ) throws -> URLRequest {
        
        guard let url = URL(string: "\(Constants.apiBaseURL)\(path)") else {
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
