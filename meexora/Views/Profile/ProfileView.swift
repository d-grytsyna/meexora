
import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel

        init(authManager: AuthManager) {
            _viewModel = StateObject(wrappedValue: ProfileViewModel(authManager: authManager))
        }
    @State private var isEditing = false

    var body: some View {
        ZStack {
            StyleGuide.Colors.primaryBackground.ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView("Loading profile...")
                    .foregroundColor(StyleGuide.Colors.secondaryText)
            } else {
                VStack(spacing: StyleGuide.Spacing.extraLarge) {
                    HStack {
                        Text("My Profile")
                            .font(StyleGuide.Fonts.largeTitle)
                            .foregroundColor(StyleGuide.Colors.primaryText)

                        Spacer()

                        Button(action: {
                            isEditing.toggle()
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(StyleGuide.Colors.accentPurple)
                                .padding(8)
                                .background(StyleGuide.Colors.secondaryBackground)
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Edit Profile")
                    }

                    VStack(spacing: StyleGuide.Spacing.large) {
                        profileBlock(title: "First Name", value: viewModel.user.firstName)
                        profileBlock(title: "Last Name", value: viewModel.user.lastName)
                        profileBlock(title: "City", value: viewModel.user.location)
                        profileBlock(title: "Birthdate", value: viewModel.formattedBirthdate)
                    }
                    .frame(maxWidth: .infinity)

                    Spacer()

                    Button(action: {
                        Task {
                            viewModel.isLoggingOut = true
                            await viewModel.logout()
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.backward.square")
                            Text("Log out")
                        }
                        .font(StyleGuide.Fonts.bodyBold)
                        .foregroundColor(StyleGuide.Colors.errorText)
                        .padding()
                        .background(StyleGuide.Colors.secondaryBackground)
                        .cornerRadius(StyleGuide.Corners.medium)
                    }
                    .accessibilityLabel("Log Out")
                }
                .padding()
            }
        }
        .sheet(isPresented: $isEditing) {
            CompleteProfileView(profile: viewModel.user)
        }
        .task {
            await viewModel.fetchUserProfile()
        }
    }


    private func profileBlock(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(StyleGuide.Fonts.bodyBold)
                .foregroundColor(StyleGuide.Colors.secondaryText)

            Text(value)
                .font(.title2)
                .foregroundColor(StyleGuide.Colors.primaryText)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(StyleGuide.Colors.secondaryBackground)
        .cornerRadius(StyleGuide.Corners.large)
        .shadow(color: StyleGuide.Shadows.color.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

