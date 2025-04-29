import SwiftUI

struct RegistrationSelectRoleView: View {
    @ObservedObject var viewModel: RegistrationViewModel

    var body: some View {
        VStack(spacing: StyleGuide.Spacing.large) {
            Text("What brings you to Meexora?")
                           .font(StyleGuide.Fonts.bodyBold)
                           .foregroundColor(StyleGuide.Colors.primaryText)
                           .padding(.top)
            
            roleButton(title: "Explorer", subtitle: "Discover and attend unique events", role: "USER", imageName: "user_role")
            roleButton(title: "Organizer", subtitle: "Create and manage events", role: "ORGANIZER", imageName: "organizer_role")
        }
    }

    private func roleButton(title: String, subtitle: String, role: String, imageName: String) -> some View {
            Button(action: {
                withAnimation {
                    viewModel.selectRole(role)
                }
            }) {
                VStack(spacing: StyleGuide.Spacing.medium) {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: StyleGuide.Corners.medium))
                    
                    VStack(spacing: StyleGuide.Spacing.small) {
                        Text(subtitle)
                            .font(StyleGuide.Fonts.body)
                            .foregroundColor(StyleGuide.Colors.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, StyleGuide.Spacing.medium)
                        Text(title)
                            .font(StyleGuide.Fonts.title)
                            .foregroundColor(StyleGuide.Colors.primaryText)
                    
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: StyleGuide.Corners.large)
                        .fill(StyleGuide.Colors.secondaryBackground.opacity(0.9))
                        .shadow(color: StyleGuide.Shadows.color, radius: StyleGuide.Shadows.radius, x: 0, y: StyleGuide.Shadows.y)
                )
            }
            .buttonStyle(.plain)
        }
}

#Preview {
    RegistrationSelectRoleView(viewModel: RegistrationViewModel())
}
