import Foundation

struct EventFieldValidator {

    static func validateTitle(_ title: String) -> ValidationResult {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        var errors: [String] = []

        if trimmed.isEmpty {
            errors.append("Title is required.")
        }
        if trimmed.count < 3 {
            errors.append("Title must be at least 3 characters.")
        }
        if trimmed.count > 255 {
            errors.append("Title must be at most 255 characters.")
        }

        return errors.isEmpty ? .success : .failure(errors)
    }

    static func validateDescription(_ description: String) -> ValidationResult {
        let trimmed = description.trimmingCharacters(in: .whitespacesAndNewlines)
        var errors: [String] = []

        if trimmed.isEmpty {
            errors.append("Description is required.")
        }
        if trimmed.count < 10 {
            errors.append("Description must be at least 10 characters.")
        }
        if trimmed.count > 10000 {
            errors.append("Description must be at most 10000 characters.")
        }

        return errors.isEmpty ? .success : .failure(errors)
    }


    static func validateDate(_ date: Date) -> ValidationResult {
        let now = Date()
        let latestAllowedCreation = date.addingTimeInterval(-3600) 

        return now > latestAllowedCreation
            ? .failure(["Event must be scheduled at least 1 hour in advance."])
            : .success
    }


    static func validateLocation(latitude: Double?, longitude: Double?, address: String) -> ValidationResult {
        var errors: [String] = []
        if latitude == nil || longitude == nil {
            errors.append("Coordinates are required.")
        }
        if address.trimmingCharacters(in: .whitespaces).isEmpty {
            errors.append("Address is required.")
        }
        return errors.isEmpty ? .success : .failure(errors)
    }

    static func validateTotalTickets(_ count: Int) -> ValidationResult {
        count >= 1
            ? .success
            : .failure(["Total tickets must be at least 1."])
    }

    static func validatePrice(_ price: Decimal) -> ValidationResult {
        price >= 0.0
            ? .success
            : .failure(["Price must be 0 or higher."])
    }

    static func validatePriceRange(min: Decimal, max: Decimal) -> ValidationResult {
        var errors: [String] = []
        if min < 0 {
            errors.append("Minimum price must be 0 or higher.")
        }
        if max < 0 {
            errors.append("Maximum price must be 0 or higher.")
        }
        if min > max {
            errors.append("Minimum price cannot be greater than maximum price.")
        }
        return errors.isEmpty ? .success : .failure(errors)
    }
}
