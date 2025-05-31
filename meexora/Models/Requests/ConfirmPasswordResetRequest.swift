struct ConfirmPasswordResetRequest: Encodable {
    let email: String
    let newPassword: String
    let code: String
}

