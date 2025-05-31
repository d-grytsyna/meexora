enum EventCategory: String, CaseIterable, Codable, Identifiable {
    case music = "MUSIC"
    case sports = "SPORTS"
    case education = "EDUCATION"
    case art = "ART"
    case food = "FOOD"
    case tech = "TECH"
    case family = "FAMILY"
    case fitness = "FITNESS"
    case general = "GENERAL"

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .music: return "Music"
        case .sports: return "Sports"
        case .education: return "Education"
        case .art: return "Art"
        case .food: return "Food & Drink"
        case .tech: return "Tech"
        case .family: return "Family"
        case .fitness: return "Fitness"
        case .general: return "Other"
        }
    }

    var iconNameLarge: String {
        switch self {
        case .music: return "icon_music"
        case .sports: return "icon_sports"
        case .education: return "icon_education"
        case .art: return "icon_art"
        case .food: return "icon_food"
        case .tech: return "icon_tech"
        case .family: return "icon_family"
        case .fitness: return "icon_fitness"
        case .general: return "icon_general"
        }
    }

    var iconNameSmall: String {
        switch self {
        case .music: return "icon_small_music"
        case .sports: return "icon_small_sports"
        case .education: return "icon_small_education"
        case .art: return "icon_small_art"
        case .food: return "icon_small_food"
        case .tech: return "icon_small_tech"
        case .family: return "icon_small_family"
        case .fitness: return "icon_small_fitness"
        case .general: return "icon_small_general"
        }
    }
}

