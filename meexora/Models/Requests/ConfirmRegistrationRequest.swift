struct ConfirmRegistrationRequest: Encodable {
    let email: String
    let password: String
    let role: String
    let code: String
}
