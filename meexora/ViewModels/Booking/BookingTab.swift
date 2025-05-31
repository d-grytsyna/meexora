enum BookingTab: String, CaseIterable, Hashable, Identifiable {
    case monitoring
    case reserved
    case paid
    case history

    var id: String { self.rawValue }

    var title: String {
        switch self {
        case .monitoring: return "Monitoring"
        case .reserved: return "Reserved"
        case .paid: return "Paid"
        case .history: return "History"
        }
    }
}
