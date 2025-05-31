import SwiftUI


struct CreateEventView: View {
    @StateObject private var viewModel = CreateEventViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                CustomFormSection(title: "Title") {
                    CustomTextField(
                        placeholder: "Enter event title",
                        text: $viewModel.newEventRequest.title,
                        isSecure: false
                    )
                }

                CustomFormSection(title: "Category") {
                    CustomPicker(
                        title: "Category",
                        options: EventCategory.allCases,
                        selection: $viewModel.newEventRequest.category,
                        labelProvider: { $0.displayName },
                        iconNameProvider: { $0.iconNameSmall }
                    )

                }


                CustomFormSection(title: "Description") {
                    CustomTextEditor(
                        placeholder: "Enter event description",
                        text: $viewModel.newEventRequest.description
                    )
                }
                CustomFormSection(title: "Date & Time") {
                    CustomDatePicker(
                        placeholder: "Select date and time",
                        selection: $viewModel.newEventRequest.date
                    )
                }
                CustomFormSection(title: "Location") {
                    LocationInputView(
                        latitude: $viewModel.newEventRequest.latitude,
                        longitude: $viewModel.newEventRequest.longitude,
                        address: $viewModel.newEventRequest.address,
                        city:
                            $viewModel.newEventRequest.city
                    )
                }
                CustomFormSection(title: "Tickets & Price") {

                    HStack(spacing: StyleGuide.Spacing.medium) {
                        VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
                            Text("Total Tickets")
                                .font(StyleGuide.Fonts.small)
                                .foregroundColor(StyleGuide.Colors.secondaryText)

                            CustomNumberField(
                                placeholder: "0",
                                value: $viewModel.newEventRequest.totalTickets,
                                minimum: 1
                            )
                        }
                        .frame(maxWidth: .infinity)

                        VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
                            Text("Price €")
                                .font(StyleGuide.Fonts.small)
                                .foregroundColor(StyleGuide.Colors.secondaryText)

                            CustomDecimalField(
                                placeholder: "0.00",
                                value: $viewModel.newEventRequest.price,
                                minimum: 0.0
                            )
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                CustomFormSection(title: "Dynamic Pricing") {
                    Toggle("Enable dynamic pricing", isOn: $viewModel.newEventRequest.dynamicPricingEnabled)
                        .foregroundColor(StyleGuide.Colors.primaryText)
                        .tint(StyleGuide.Colors.accentYellow)

                    if viewModel.newEventRequest.dynamicPricingEnabled {
                        HStack(spacing: StyleGuide.Spacing.medium) {
                            VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
                                Text("Min price €")
                                    .font(StyleGuide.Fonts.small)
                                    .foregroundColor(StyleGuide.Colors.secondaryText)

                                CustomDecimalField(
                                    placeholder: "1.00",
                                    value: $viewModel.newEventRequest.minPrice,
                                    minimum: 1
                                )
                            }
                            .frame(maxWidth: .infinity)

                            VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
                                Text("Max price €")
                                    .font(StyleGuide.Fonts.small)
                                    .foregroundColor(StyleGuide.Colors.secondaryText)

                                CustomDecimalField(
                                    placeholder: "100.00",
                                    value: $viewModel.newEventRequest.maxPrice,
                                    minimum: 0.0
                                )
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                

                }
                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(StyleGuide.Colors.errorText)
                        .font(StyleGuide.Fonts.small)
                        .padding(.bottom)
                }

                Button {
                    Task {
                        await viewModel.submit()
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView().modifier(StyleGuide.ProgressButtons.primary())
                    } else {
                        Text("Create Event")
                            .frame(maxWidth: .infinity)
                    }
                }
                .modifier(StyleGuide.Buttons.primary())
                .disabled(viewModel.isLoading)


            }
            .standardPagePadding()
        }
        .navigationTitle("New Event")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    NavigationStack {
        CreateEventView()
    }
}
