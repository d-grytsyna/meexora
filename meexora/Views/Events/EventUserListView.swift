import SwiftUI

struct EventUserListView: View {
    @StateObject private var viewModel = EventUserListViewModel()
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView("Loading events...")
            } else if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            } else if viewModel.events.isEmpty {
                Text("No events available")
                    .foregroundColor(.gray)
            } else {
                List(viewModel.events) { event in
                    NavigationLink(destination: EventUserInfoView(event: event)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.title)
                                .font(.headline)
                            Text(event.description)
                                .font(.subheadline)
                                .lineLimit(2)
                            Text(event.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 6)
                    }
                }
                .navigationTitle("Available Events")
            }
        }
        .task {
            await viewModel.fetchEvents()
        }
    }
}
