struct ResetPasswordValidator {

    static func validate(code: String, password: String) -> ValidationResult {
        var errors: [String] = []

        switch FieldValidator.validateVerificationCode(code) {
        case .failure(let codeErrors):
            errors.append(contentsOf: codeErrors)
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
