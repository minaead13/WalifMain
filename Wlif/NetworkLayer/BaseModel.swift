//
//  BaseModel.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import Foundation

struct BaseModel <T: Codable>: Codable {
    let code: Int?
    let data: T?
    let message: String?
    let pagination: Pagination?
}

// MARK: - Pagination
struct Pagination: Codable {
    var total, perPage, currentPage, lastPage: Int?
    var from, to: Int?

    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case from, to
    }
}
