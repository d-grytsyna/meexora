import Foundation

struct RegistrationValidator {

    static func validate(email: String, password: String) -> ValidationResult {
        var errors: [String] = []

        switch FieldValidator.validateEmail(email) {
        case .failure(let emailErrors):
            errors.append(contentsOf: emailErrors)
        case .success:
            break
        }

        switch FieldValidator.validateRegistrationPassword(password) {
        case .failure(let passwordErrors):
            errors.append(contentsOf: passwordErrors)
        case .success:
            break
        }

        return errors.isEmpty ? .success : .failure(errors)
    }
}
