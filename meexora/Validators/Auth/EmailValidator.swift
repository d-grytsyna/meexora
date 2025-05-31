struct EmailValidator {
    static func validate(email: String) -> ValidationResult {
        if case let .failure(emailErrors) = FieldValidator.validateEmail(email) {
            return .failure(emailErrors)
        }
        return .success
    }
}

