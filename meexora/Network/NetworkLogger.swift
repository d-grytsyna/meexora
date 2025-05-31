import Foundation

struct NetworkLogger {
    static func log(request: URLRequest) {
        print("Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
        if let headers = request.allHTTPHeaderFields {
            print("Headers:", headers)
        }
        if let body = request.httpBody {
            print("Body:", String(data: body, encoding: .utf8) ?? "")
        }
    }

    static func log(response: URLResponse?, data: Data?) {
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status: \(httpResponse.statusCode)")
        }
        if let data = data {
            print("Response Body:", String(data: data, encoding: .utf8) ?? "")
        }
    }
}
