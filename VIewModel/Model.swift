struct APIResponse: Codable {
    let success: Bool
    let page: Int
    let total_pages: Int
    let total_users: Int
    let count: Int
    let links: Links
    let users: [User]
}

struct Links: Codable {
    let next_url: String?
    let prev_url: String?
}

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let position_id: Int
    let registration_timestamp: Int
    let photo: String
}
