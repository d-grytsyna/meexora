import Foundation

struct FieldValidator {

    static func validateEmail(_ email: String) -> ValidationResult {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedEmail.isEmpty {
            return .failure(["Email field cannot be empty"])
        }

        if trimmedEmail.count > 255 {
            return .failure(["Email must be less than 255 characters"])
        }

        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: trimmedEmail) {
            return .failure(["Please enter a valid email address"])
        }

        return .success
    }

    static func validatePassword(_ password: String) -> ValidationResult {
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedPassword.isEmpty {
            return .failure(["Password field cannot be empty"])
        }

        if trimmedPassword.count < 8 {
            return .failure(["Password must be at least 8 characters long"])
        }

        if trimmedPassword.count > 128 {
            return .failure(["Password must be less than 128 characters"])
        }
        return .success
    }
    
    static func validateRegistrationPassword(_ password: String) -> ValidationResult {
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedPassword.isEmpty {
            return .failure(["Password field cannot be empty"])
        }

        if trimmedPassword.count < 8 {
            return .failure(["Password must be at least 8 characters long"])
        }

        if trimmedPassword.count > 128 {
            return .failure(["Password must be less than 128 characters"])
        }
        return .success
    }
    
    static func validateVerificationCode(_ code: String) -> ValidationResult {
          let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)

          if trimmedCode.isEmpty {
              return .failure(["Verification code cannot be empty."])
          }

          return .success
      }
    
    
    static func validateFirstName(_ name: String) -> ValidationResult {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .failure(["First name is required"])
        }

        if trimmed.count > 64 {
            return .failure(["First name must be at most 64 characters"])
        }

        return .success
    }
    
    
    static func validateLastName(_ name: String) -> ValidationResult {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .failure(["Last name is required"])
        }

        if trimmed.count > 64 {
            return .failure(["Last name must be at most 64 characters"])
        }

        return .success
    }
    
    static func validateLocation(_ location: String) -> ValidationResult {
        let trimmed = location.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return .failure(["Location is required"])
        }

        if trimmed.count > 128 {
            return .failure(["Location must be at most 128 characters"])
        }

        return .success
    }


    static func validateBirthdate(_ date: Date?) -> ValidationResult {
        guard let date = date else {
            return .success
        }

        let today = Date()
        if date > today {
            return .failure(["Birthdate cannot be in the future"])
        }

        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date, to: today)
        if let age = ageComponents.year, age < 13 {
            return .failure(["You must be at least 13 years old"])
        }

        return .success
    }

    
    


}
