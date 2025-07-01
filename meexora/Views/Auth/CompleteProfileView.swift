import SwiftUI

struct CompleteProfileView: View {
    @StateObject private var viewModel = CompleteProfileViewModel()
    @StateObject private var locationManager = LocationManagerService()
    @StateObject private var citySearchService = CitySearchService()

    @State private var didSaveProfile = false
    @State private var didAutofill = false
    @State private var isSelecting = false
    @State private var isAutofillFromLocation = false
    init(profile: UserProfileDto? = nil) {
            _viewModel = StateObject(wrappedValue: CompleteProfileViewModel(profile: profile))
        }
    var body: some View {
        ZStack {
            StyleGuide.Colors.primaryBackground.ignoresSafeArea()

            VStack(spacing: StyleGuide.Spacing.large) {
                VStack(spacing: StyleGuide.Spacing.small) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)

                    Text("Welcome to Meexora")
                        .font(StyleGuide.Fonts.largeTitle)
                        .foregroundColor(StyleGuide.Colors.primaryText)
                        .multilineTextAlignment(.center)

                    Text("Let’s complete your profile to get started")
                        .font(StyleGuide.Fonts.bodyBold)
                        .foregroundColor(StyleGuide.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                VStack(spacing: StyleGuide.Spacing.medium) {
                    CustomTextField(placeholder: "First Name", text: $viewModel.firstName, isSecure: false)
                    CustomTextField(placeholder: "Last Name", text: $viewModel.lastName, isSecure: false)
                    CustomTextField(placeholder: "City", text: $viewModel.location, isSecure: false)
                        .onChange(of: viewModel.location) {
                            guard !isSelecting, !isAutofillFromLocation else {
                                isSelecting = false
                                isAutofillFromLocation = false
                                return
                            }
                            citySearchService.searchCity(query: viewModel.location)
                        }

                    if citySearchService.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }

                    if !citySearchService.results.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(citySearchService.results) { city in
                                Button {
                                    isSelecting = true
                                    viewModel.location = "\(city.city), \(city.country)"
                                    citySearchService.results = []
                                } label: {
                                    HStack {
                                        Text("\(city.city),")
                                            .foregroundColor(StyleGuide.Colors.primaryText)
                                        Text(city.country).foregroundColor(StyleGuide.Colors.accentPurple)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }

                    if locationManager.isLoading {
                        Text("Detecting location...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    if locationManager.locationDenied {
                        Text("Location access denied. Please enter your city manually.")
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                    DatePicker("Birthdate", selection: $viewModel.birthdate,  in: ...Date.now, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding()
                        .background(StyleGuide.Colors.secondaryBackground)
                        .cornerRadius(StyleGuide.Corners.medium)

                    if let error = viewModel.error {
                        Text(error)
                            .font(StyleGuide.Fonts.small)
                            .foregroundColor(StyleGuide.Colors.errorText)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal)

                Button(action: {
                    Task {
                        let success = await viewModel.saveProfile()
                        if success {
                            didSaveProfile = true
                        }
                    }
                }) {
                    if viewModel.isSaving {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: StyleGuide.Colors.buttonText))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(StyleGuide.Colors.buttonSecondaryBackground)
                            .cornerRadius(StyleGuide.Corners.medium)
                            .shadow(color: StyleGuide.Shadows.color, radius: StyleGuide.Shadows.radius, x: StyleGuide.Shadows.x, y: StyleGuide.Shadows.y)
                    } else {
                        Text("Save Profile")
                            .modifier(StyleGuide.Buttons.accent())
                    }
                }
                .disabled(viewModel.isSaving)
                .padding(.horizontal)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $didSaveProfile) {
            MainTabView()
        }
        .onAppear {
            locationManager.requestCityDetection()
        }
        .onChange(of: locationManager.detectedLocation) { _, newValue in
            if !didAutofill,
               let city = newValue?.city,
               let country = newValue?.country,
               viewModel.location.isEmpty {
                viewModel.location = "\(city), \(country)"
                isSelecting = true
                isAutofillFromLocation = true
                didAutofill = true
            }
        }
    }
}

#Preview {
    CompleteProfileView()
}
