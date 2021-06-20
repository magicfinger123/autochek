//
//  CarListResponse.swift
//  autocheck
//
//  Created by CWG Mobile Dev on 18/06/2021.
//

import Foundation
struct CarListResponse: Codable {
    let result: [Car]?
    let pagination: Pagination?

    enum CodingKeys: String, CodingKey {
        case result
        case pagination
    }
}
struct Car: Codable {
    let id: String?
    let title: String?
    let imageURL: String?
    let year: Int?
    let city: String?
    let state: String?
    let gradeScore: Double?
    let sellingCondition: String?
    let hasWarranty: Bool?
    let marketplacePrice: Int?
    let marketplaceOldPrice: Int?
    let hasFinancing: Bool?
    let mileage: Int?
    let mileageUnit: MileageUnit?
    let installment: Int?
    let depositReceived: Bool?
    let loanValue: Int?
    let websiteURL: String?
    let stats: Stats?
    let bodyTypeID: String?
    let sold: Bool?
    let hasThreeDImage: Bool?

    enum CodingKeys: String, CodingKey {
          case id, title
          case imageURL = "imageUrl"
          case year, city, state, gradeScore, sellingCondition, hasWarranty, marketplacePrice, marketplaceOldPrice, hasFinancing, mileage, mileageUnit, installment, depositReceived, loanValue
          case websiteURL = "websiteUrl"
          case stats
          case bodyTypeID = "bodyTypeId"
          case sold, hasThreeDImage
      }
}

enum MileageUnit: String, Codable {
    case km = "km"
    case miles = "miles"
}


// MARK: - Stats
struct Stats: Codable {
    let webViewCount: Int?
    let webViewerCount: Int?
    let interestCount: Int?
    let testDriveCount: Int?
    let appViewCount: Int?
    let appViewerCount: Int?
    let processedLoanCount: Int?

    enum CodingKeys: String, CodingKey {
        case webViewCount
        case webViewerCount
        case interestCount
        case testDriveCount
        case appViewCount
        case appViewerCount
        case processedLoanCount
    }
}
