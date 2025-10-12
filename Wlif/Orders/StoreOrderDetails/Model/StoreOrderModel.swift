//
//  StoreOrderModel.swift
//  Wlif
//
//  Created by OSX on 03/09/2025.
//

import Foundation

// MARK: - StoreOrderModel
struct StoreOrderModel: Codable {
    var id: Int?
    var orderNumber: String?
    var merchantID: Int?
    var merchantImage: String?
    var merchantName: String?
    var merchantRate: Int?
    var status: String?
    var statusValue: Int?
    var isRated, paid: Bool?
    var address: Int?
    var lat, lon, addressName: String?
    var paymentType: Int?
    var paymentGatway: String?
    var deliveryValue: String?
    var subtotal: Int?
    var tax, total: Double?
    var itemsCount: Int?
    var createdAt: String?
    var items: [Item]?
    var rate: Rate?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNumber = "order_number"
        case merchantID = "merchant_id"
        case merchantImage = "merchant_image"
        case merchantName = "merchant_name"
        case merchantRate = "merchant_rate"
        case status
        case statusValue = "status_value"
        case isRated = "is_rated"
        case paid,address, lat, lon
        case addressName = "address_name"
        case paymentType = "payment_type"
        case paymentGatway = "payment_gatway"
        case deliveryValue = "delivery_value"
        case subtotal, tax, total
        case itemsCount = "items_count"
        case createdAt = "created_at"
        case items, rate
    }
}


// MARK: - Rate
struct Rate: Codable {
    var id, rate: Int?
    var comment: String?
}
