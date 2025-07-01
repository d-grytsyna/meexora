import SwiftUI

struct EditEventView: View {
    @StateObject private var viewModel: EditEventViewModel
    let eventId: UUID

    init(eventId: UUID) {
        self.eventId = eventId
        _viewModel = StateObject(wrappedValue: EditEventViewModel(eventId: eventId))
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading ...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(StyleGuide.Colors.secondaryText)
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        CustomFormSection(title: "Title") {
                            CustomTextField(
                                placeholder: "Enter event title",
                                text: $viewModel.editEventRequest.title,
                                isSecure: false
                            )
                        }

                        CustomFormSection(title: "Category") {
                            CustomPicker(
                                title: "Category",
                                options: EventCategory.allCases,
                                selection: $viewModel.editEventRequest.category,
                                labelProvider: { $0.displayName },
                                iconNameProvider: { $0.iconNameSmall }
                            )
                        }

                        CustomFormSection(title: "Description") {
                            CustomTextEditor(
                                placeholder: "Enter event description",
                                text: $viewModel.editEventRequest.description
                            )
                        }

                        CustomFormSection(
                            title: "Date & Time",
                            subtitle: "Changing the date and time will notify all users who purchased tickets."
                        ) {
                            CustomDatePicker(
                                placeholder: "Select date and time",
                                selection: $viewModel.editEventRequest.date
                            )
                        }

                        CustomFormSection(
                            title: "Location",
                            subtitle: "Users who purchased tickets will be informed about any location change."
                        ) {
                            LocationInputView(
                                latitude: $viewModel.editEventRequest.latitude,
                                longitude: $viewModel.editEventRequest.longitude,
                                address: $viewModel.editEventRequest.address,
                                city: $viewModel.editEventRequest.city
                            )
                        }

                        CustomFormSection(title: "Tickets & Price",
                                          subtitle: "You can only increase current ticket amount") {
                            HStack(spacing: StyleGuide.Spacing.medium) {
                                VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
                                    Text("Current amount: \(viewModel.editEventRequest.totalTickets)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .font(StyleGuide.Fonts.small)
                                        .foregroundColor(StyleGuide.Colors.secondaryText)

                                    CustomNumberField(
                                        placeholder: "0",
                                        value:  $viewModel.editEventRequest.addTickets,
                                        minimum: 0
                                    )
                                }
                                .frame(maxWidth: .infinity)

                                VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
                                    Text("Price €")
                                        .font(StyleGuide.Fonts.small)
                                        .foregroundColor(StyleGuide.Colors.secondaryText)

                                    CustomDecimalField(
                                        placeholder: "0.00",
                                        value: $viewModel.editEventRequest.price,
                                        minimum: 0.0
                                    )
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }

                        CustomFormSection(title: "Dynamic Pricing") {
                            Toggle("Enable dynamic pricing", isOn: $viewModel.editEventRequest.dynamicPricingEnabled)
                                .foregroundColor(StyleGuide.Colors.primaryText)
                                .tint(StyleGuide.Colors.accentYellow)

                            if viewModel.editEventRequest.dynamicPricingEnabled {
                                HStack(spacing: StyleGuide.Spacing.medium) {
                                    VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
                                        Text("Min price €")
                                            .font(StyleGuide.Fonts.small)
                                            .foregroundColor(StyleGuide.Colors.secondaryText)

                                        CustomDecimalField(
                                            placeholder: "1.00",
                                            value: $viewModel.editEventRequest.minPrice,
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
                                            value: $viewModel.editEventRequest.maxPrice,
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
                                Text("Save Changes")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .modifier(StyleGuide.Buttons.primary())
                        .disabled(viewModel.isLoading)
                    }
                    .standardPagePadding()
                }
            }
        }
        .navigationTitle("Edit Event")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchEventDetails()
        }
    }
}
