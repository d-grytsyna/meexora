import Foundation

struct CreateProfileValidator {

    static func validate(firstName: String, lastName: String, birthdate: Date, location: String) -> ValidationResult {
        var errors: [String] = []

        switch FieldValidator.validateFirstName(firstName) {
        case .failure(let firstNameErrors):
            errors.append(contentsOf: firstNameErrors)
        case .success:
            break
        }

        switch FieldValidator.validateLastName(lastName) {
        case .failure(let lastNameErrors):
            errors.append(contentsOf: lastNameErrors)
        case .success:
            break
        }
        
        switch FieldValidator.validateLocation(location) {
        case .failure(let locationErrors):
            errors.append(contentsOf: locationErrors)
        case .success:
            break
        }

        switch FieldValidator.validateBirthdate(birthdate) {
        case .failure(let birthdateErrors):
            errors.append(contentsOf: birthdateErrors)
        case .success:
            break
        }

        return errors.isEmpty ? .success : .failure(errors)
    }
}
