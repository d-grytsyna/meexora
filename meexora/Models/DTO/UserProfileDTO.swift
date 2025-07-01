import Foundation

struct UserProfileDto: Codable {
    let firstName: String
    let lastName: String
    let birthdate: String
    let location: String
    
    var formattedBirthdate: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            guard let date = formatter.date(from: birthdate) else { return birthdate }

            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
    
}


