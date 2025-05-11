struct StripeAccountStatus: Decodable {
    let chargesEnabled: Bool
    let payoutsEnabled: Bool
    let detailsSubmitted: Bool
}
