//
//  PopularMakeResponse.swift
//  autocheck
//
//  Created by CWG Mobile Dev on 18/06/2021.
//

struct PopularMakeResponse: Codable {
    let makeList: [MakeList]?
    let pagination: Pagination?

    enum CodingKeys: String, CodingKey {
        case makeList
        case pagination
    }
}
// MARK: - MakeList
struct MakeList: Codable {
    let id: Int?
    let name: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "imageUrl"
    }
}
// MARK: - Pagination
struct Pagination: Codable {
    let total: Int?
    let currentPage: Int?
    let pageSize: Int?

    enum CodingKeys: String, CodingKey {
        case total
        case currentPage
        case pageSize
    }
}
