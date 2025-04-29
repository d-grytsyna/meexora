import Foundation

struct FieldValidator {

    static func validateEmail(_ email: String) -> ValidationResult {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedEmail.isEmpty {
            return .failure(["Email field cannot be empty"])
        }

        if trimmedEmail.count > 255 {
            return .failure(["Email must be less than 255 characters"])
        }

        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: trimmedEmail) {
            return .failure(["Please enter a valid email address"])
        }

        return .success
    }

    static func validatePassword(_ password: String) -> ValidationResult {
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedPassword.isEmpty {
            return .failure(["Password field cannot be empty"])
        }

        if trimmedPassword.count < 8 {
            return .failure(["Password must be at least 8 characters long"])
        }

        if trimmedPassword.count > 128 {
            return .failure(["Password must be less than 128 characters"])
        }
        return .success
    }
    
    static func validateRegistrationPassword(_ password: String) -> ValidationResult {
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedPassword.isEmpty {
            return .failure(["Password field cannot be empty"])
        }

        if trimmedPassword.count < 8 {
            return .failure(["Password must be at least 8 characters long"])
        }

        if trimmedPassword.count > 128 {
            return .failure(["Password must be less than 128 characters"])
        }
        return .success
    }
    
}
