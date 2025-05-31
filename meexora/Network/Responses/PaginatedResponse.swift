struct PaginatedResponse<T: Decodable>: Decodable {
    let content: [T]
    let totalPages: Int
    let totalElements: Int
    let number: Int
    let size: Int
}
