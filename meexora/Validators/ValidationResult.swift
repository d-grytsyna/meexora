import Foundation

enum ValidationResult {
    case success
    case failure([String])
}

extension ValidationResult {
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }

    var isFailure: Bool {
        !isSuccess
    }

    var errorMessages: [String] {
        switch self {
        case .success:
            return []
        case .failure(let errors):
            return errors
        }
    }
}
