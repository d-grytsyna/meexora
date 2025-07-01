struct EditEventValidator {

    static func validate(_ request: EditEventDTO) -> ValidationResult {
        var errors: [String] = []

        switch EventFieldValidator.validateTitle(request.title) {
        case .failure(let e): errors.append(contentsOf: e)
        case .success: break
        }

        switch EventFieldValidator.validateDescription(request.description) {
        case .failure(let e): errors.append(contentsOf: e)
        case .success: break
        }

        switch EventFieldValidator.validateDate(request.date) {
        case .failure(let e): errors.append(contentsOf: e)
        case .success: break
        }

        switch EventFieldValidator.validateLocation(latitude: request.latitude, longitude: request.longitude, address: request.address) {
        case .failure(let e): errors.append(contentsOf: e)
        case .success: break
        }

        switch EventFieldValidator.validateTotalTickets(request.totalTickets) {
        case .failure(let e): errors.append(contentsOf: e)
        case .success: break
        }

        switch EventFieldValidator.validatePrice(request.price) {
        case .failure(let e): errors.append(contentsOf: e)
        case .success: break
        }

        if request.dynamicPricingEnabled {
            switch EventFieldValidator.validatePriceRange(min: request.minPrice, max: request.maxPrice) {
            case .failure(let e): errors.append(contentsOf: e)
            case .success: break
            }
        }

        return errors.isEmpty ? .success : .failure(errors)
    }
}
