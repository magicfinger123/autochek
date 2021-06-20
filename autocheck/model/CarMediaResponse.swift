//
//  CarMediaResponse.swift
//  autocheck
//
//  Created by CWG Mobile Dev on 18/06/2021.
//

import Foundation
struct CarMediaResponse: Codable {
    let carMediaList: [CarMediaList]?
    let pagination: Pagination?

    enum CodingKeys: String, CodingKey {
        case carMediaList
        case pagination
    }
}

// MARK: - CarMediaList
struct CarMediaList: Codable {
    let id: Int?
    let name: String?
    let url: String?
    let createdAt: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case createdAt
        case type
    }
}
