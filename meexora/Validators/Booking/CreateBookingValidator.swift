
struct CreateBookingValidator {
    
    static func validateTickets(_ ticketNames: [String]) -> ValidationResult {
        var errors: [String] = []

        if ticketNames.isEmpty {
            errors.append("You must provide at least one ticket.")
        }

        for (index, name) in ticketNames.enumerated() {
            let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimmed.isEmpty {
                errors.append("Ticket #\(index + 1) is empty.")
            } else if trimmed.count < 3 {
                errors.append("Ticket #\(index + 1) must be at least 3 characters.")
            } else if trimmed.count > 255 {
                errors.append("Ticket #\(index + 1) must be at most 255 characters.")
            }
        }

        return errors.isEmpty ? .success : .failure(errors)
    }
}

