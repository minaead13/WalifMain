//
//  OfferStoresDetailsModel.swift
//  Wlif
//
//  Created by OSX on 17/08/2025.
//

import Foundation

struct OfferStoresDetailsModel: Codable {
    var id, merchantID: Int?
    var image: String?
    var name: String?
    var priceBefore, price: Int?
    var desc: String?
    var sizes: [Size]?
    var colors: [Color]?
    var discountPercentage: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case merchantID = "merchant_id"
        case image, name
        case priceBefore = "price_before"
        case price, desc, sizes, colors
        case discountPercentage = "discount_percentage"
    }
}

struct Size: Codable {
    var id: Int?
    var size: String?
}

struct Color: Codable {
    var id: Int?
    var color: String?
}

// MARK: - OfferHotelDetailsModel
struct OfferHotelDetailsModel: Codable {
    var id, merchantID: Int?
    var name: String?
    var animalsNumber, price, oldPrice, discountPercentage: Int?
    var services: [Service]?

    enum CodingKeys: String, CodingKey {
        case id
        case merchantID = "merchant_id"
        case name
        case animalsNumber = "animals_number"
        case price
        case oldPrice = "old_price"
        case discountPercentage = "discount_percentage"
        case services
    }
}

// MARK: - OfferVeterinaryServicesDetailsModel
struct OfferVeterinaryServicesDetailsModel: Codable {
    var id, merchantID: Int?
    var name, desc: String?
    var rate, price, oldPrice, discountPercentage: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case merchantID = "merchant_id"
        case name, desc, rate, price
        case oldPrice = "old_price"
        case discountPercentage = "discount_percentage"
    }
}
