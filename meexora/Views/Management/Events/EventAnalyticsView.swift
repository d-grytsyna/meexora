import SwiftUI
import Charts

struct EventAnalyticsView: View {
    @StateObject private var viewModel: EventAnalyticsViewModel

    init(eventId: UUID, eventDate: Date) {
        _viewModel = StateObject(wrappedValue: EventAnalyticsViewModel(eventId: eventId, eventDate: eventDate))
    }


    var body: some View {
      
            VStack(alignment: .leading, spacing: StyleGuide.Spacing.large) {
                if viewModel.isLoading {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                } else if let stats = viewModel.salesStatsResponse,
                            let scanningStats = viewModel.scanningStats{
                    
                    Text("Ticket Sales Analytics")
                        .font(StyleGuide.Fonts.title)
                        .foregroundColor(StyleGuide.Colors.primaryText)
                    
                    VStack(alignment: .leading, spacing: StyleGuide.Spacing.small) {
                        HStack {
                            Text("Total Tickets Sold:")
                            Text("\(stats.totalTicketsSold)")
                                .font(StyleGuide.Fonts.title)
                                .fontWeight(.bold)
                                .foregroundColor(StyleGuide.Colors.accentPurple)
                        }
                        
                        HStack {
                            Text("Total Revenue:")
                            Text("\(stats.totalRevenue.formatted()) €")
                                .font(StyleGuide.Fonts.title)
                                .fontWeight(.bold)
                                .foregroundColor(StyleGuide.Colors.accentPurple)
                        }
                        
                        HStack {
                            Text("Scanned amount:")
                            Text("\(scanningStats.validated)")
                                .font(StyleGuide.Fonts.title)
                                .fontWeight(.bold)
                                .foregroundColor(StyleGuide.Colors.accentPurple)
                        }
                    }
                    .font(StyleGuide.Fonts.body)
                    .foregroundColor(StyleGuide.Colors.primaryText)
                    
                    
                    VStack(alignment: .leading, spacing: StyleGuide.Spacing.medium) {
                        Text("Ticket Sales Over Time")
                            .font(StyleGuide.Fonts.title)
                            .foregroundColor(StyleGuide.Colors.primaryText)
                        
                        if stats.dailySales.isEmpty {
                            Text("No data to display")
                                .font(StyleGuide.Fonts.body)
                                .foregroundColor(StyleGuide.Colors.secondaryText)
                                .frame(height: 200)
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {

                            ScrollView(.horizontal) {
                                Chart(stats.dailySales) { day in
                                    BarMark(
                                        x: .value("Date", day.date, unit: .day),
                                        y: .value("Tickets", day.ticketsSold)
                                    )
                                    .foregroundStyle(StyleGuide.Colors.accentPurple)
                                    .annotation(position: .top, alignment: .center, spacing: 2) {
                                        if day.ticketsSold > 0 {
                                            VStack(spacing: 2) {
                                                Text("\(day.ticketsSold) tickets")
                                                    .font(.caption)
                                                    .bold()
                                                Text("\(day.totalPrice.formatted()) €")
                                                    .font(.caption2)
                                                    .foregroundColor(StyleGuide.Colors.secondaryText)
                                            }
                                            .padding(4)
                                            .background(StyleGuide.Colors.secondaryBackground)
                                            .cornerRadius(6)
                                        }
                                    }

                                } .frame(width: CGFloat(stats.dailySales.count) * 60, height: 250)
                                    .chartXAxis {
                                        AxisMarks(values: .stride(by: .day)) { _ in
                                            AxisGridLine()
                                            AxisTick()
                                            AxisValueLabel(format: .dateTime.day().month())
                                        }
                                    }
                                    .padding(StyleGuide.Padding.small)



                         
                            }


                            

                            
                        }
                        
                    }
                }else if let error =  viewModel.error{
                    Spacer()
                    Text(error)
                        .font(StyleGuide.Fonts.bodyBold)
                        .foregroundColor(StyleGuide.Colors.errorText)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                    Spacer()
                    
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(StyleGuide.Colors.secondaryBackground)
            .cornerRadius(StyleGuide.Corners.medium)
            .onAppear {
                Task {
                    await viewModel.fetchAllData()
                }
            }
        }
    
}


#Preview {
    EventAnalyticsView(eventId: UUID(), eventDate: Date())
}
