import Foundation
import SwiftUI

@MainActor
final class CompleteProfileViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthdate: Date = Date()
    @Published var location: String = ""

    @Published var isSaving = false
    @Published var error: String?

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
            isSaving = false
            return true
        } catch {
            self.error = error.localizedDescription
            return false
        };
    }
}
