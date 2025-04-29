import SwiftUI

struct RegistrationEnterEmailView: View {
    @ObservedObject var viewModel: RegistrationViewModel

    var body: some View {
        VStack(spacing: StyleGuide.Spacing.medium) {
            CustomTextField(placeholder: "Email", text: $viewModel.email, isSecure: false)
            CustomTextField(placeholder: "Password", text: $viewModel.password, isSecure: true)
        }
    }
}
