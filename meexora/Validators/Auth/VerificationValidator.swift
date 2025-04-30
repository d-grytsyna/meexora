struct VerificationValidator {
    static func validate(code: String) -> ValidationResult {
        if case let .failure(codeErrors) = FieldValidator.validateVerificationCode(code) {
            return .failure(codeErrors)
        }
        return .success
    }
}

