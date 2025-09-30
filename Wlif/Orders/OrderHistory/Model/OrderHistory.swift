//
//  OrderHistory.swift
//  Wlif
//
//  Created by OSX on 02/09/2025.
//

import Foundation

// MARK: - OrderHistory
struct OrderHistory: Codable {
    var data: [OrderData]?
    var links: Links?
    var meta: Meta?
}

// MARK: - BookOrderHistory
struct BookOrderHistory: Codable {
    var data: [ClinicAndHotelOrderHistory]?
    var links: Links?
    var meta: Meta?
}


// MARK: - OrderData
struct OrderData: Codable {
    var id: Int?
    var orderNumber: String?
    var merchantID: Int?
    var merchantImage: String?
    var merchantName: String?
    var merchantRate: Int?
    var status: String?
    var statusValue: Int?
    var subtotal, tax, total: String?
    var itemsCount: Int?
    var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNumber = "order_number"
        case merchantID = "merchant_id"
        case merchantImage = "merchant_image"
        case merchantName = "merchant_name"
        case merchantRate = "merchant_rate"
        case status
        case statusValue = "status_value"
        case subtotal, tax, total
        case itemsCount = "items_count"
        case createdAt = "created_at"
    }
}

// MARK: - ClinicAndHotelOrderHistory
struct ClinicAndHotelOrderHistory: Codable {
    var id: Int?
    var orderNumber: String?
    var merchantID: Int?
    var merchantImage: String?
    var merchantName: String?
    var merchantRate: Int?
    var serviceType, status: String?
    var statusValue: Int?
    var subtotal, tax, total: String?
    var entryDate, exitDate: String?
    var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNumber = "order_number"
        case merchantID = "merchant_id"
        case merchantImage = "merchant_image"
        case merchantName = "merchant_name"
        case merchantRate = "merchant_rate"
        case serviceType = "service_type"
        case status
        case statusValue = "status_value"
        case subtotal, tax, total
        case entryDate = "entry_date"
        case exitDate = "exit_date"
        case createdAt = "created_at"
    }
}

// MARK: - Links
struct Links: Codable {
    var first, last: String?
    var prev, next: String?
}

// MARK: - Meta
struct Meta: Codable {
    var currentPage, from, lastPage: Int?
    var links: [Link]?
    var path: String?
    var perPage, to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case links, path
        case perPage = "per_page"
        case to, total
    }
}

// MARK: - Link
struct Link: Codable {
    var url: String?
    var label: String?
    var active: Bool?
}
