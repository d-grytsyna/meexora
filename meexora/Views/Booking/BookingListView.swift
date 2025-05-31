import SwiftUI

enum BookingRoute: Identifiable, Hashable {
    case payment(BookingResponse)
    case details(BookingResponse)
    
    var id: UUID {
        switch self {
        case .payment(let booking), .details(let booking):
            return booking.id
        }
    }
    static func == (lhs: BookingRoute, rhs: BookingRoute) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


struct BookingListView: View {
    @StateObject private var viewModel = BookingListViewModel()
    @State private var selectedRoute: BookingRoute?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Status", selection: $viewModel.selectedTab) {
                    ForEach(BookingTab.allCases, id: \.self) { tab in
                        Text(tab.title).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, StyleGuide.Padding.medium)
                .padding(.top, StyleGuide.Padding.medium)

                contentView
            }
            
            .navigationTitle("My Bookings")
            .navigationDestination(item: $selectedRoute) { route in
                switch route {
                case .payment(let booking):
                    BookingPaymentView(booking: booking)
                case .details(let booking):
                    BookingDetailView(booking: booking)
                }
            }
            .task {
                await viewModel.loadBookings()
            }
        }.background(StyleGuide.Colors.primaryBackground)
    }

    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            ProgressView("Loading bookings...")
                .font(StyleGuide.Fonts.body)
                .foregroundColor(StyleGuide.Colors.secondaryText)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .font(StyleGuide.Fonts.body)
                .foregroundColor(StyleGuide.Colors.errorText)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.filteredBookings.isEmpty {
            Text("No bookings found")
                .font(StyleGuide.Fonts.body)
                .foregroundColor(StyleGuide.Colors.secondaryText)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(viewModel.filteredBookings, id: \.id) { booking in
                Button {
                    if booking.status == "RESERVED" {
                        selectedRoute = .payment(booking)
                    } else {
                        selectedRoute = .details(booking)
                    }
                } label: {
                    BookingRowView(booking: booking)
                }
                .buttonStyle(.plain)
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
        }
    }
}
