import Foundation
import SwiftUI

@MainActor
final class CompleteProfileViewModel: ObservableObject {
    @Published var firstName: String
        @Published var lastName: String
        @Published var birthdate: Date
        @Published var location: String

        @Published var isSaving = false
        @Published var error: String?
    @AppStorage("userCity") private var cachedCity: String = ""
    init(profile: UserProfileDto? = nil) {
        if let profile = profile {
            self.firstName = profile.firstName
            self.lastName = profile.lastName
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "en_US_POSIX")

            self.birthdate = formatter.date(from: profile.birthdate) ?? Date()
            self.location = profile.location
        } else {
            self.firstName = ""
            self.lastName = ""
            self.birthdate = Date()
            self.location = ""
        }
    }


    func saveProfile() async -> Bool {
        isSaving = true
        error = nil

        let validationResult = CreateProfileValidator.validate(firstName: firstName, lastName: lastName, birthdate: birthdate, location: location)
        
        if validationResult.isFailure {
            self.error = validationResult.errorMessages.first
            self.isSaving = false
            return false
        }
        
        let dateString = DateFormatter.yyyyMMdd.string(from: birthdate)
        let dto = UserProfileDto(
            firstName: firstName,
            lastName: lastName,
            birthdate: dateString,
            location: location
        )

        do {
            try await UserService.saveProfile(dto)
            cachedCity = dto.location
            isSaving = false
            return true
        } catch {
            self.error = error.localizedDescription
            return false
        };
    }
}
