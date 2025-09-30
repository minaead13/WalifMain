//
//  OffersModel.swift
//  Wlif
//
//  Created by OSX on 13/08/2025.
//

import Foundation

struct OffersModel: Codable {
    var stores: [StoreOffer]?
    var clinics, hotels: [Clinic]?
}

struct StoreOffer: Codable {
    var id: Int?
    var image: String?
    var attachments: [Attachements]?
    var name, shortDesc, location, delivery: String?
    var distance: String?
    var rate: Int?
    var minuim, closesAt: String?
    var offers: [StoreOffers]?

    enum CodingKeys: String, CodingKey {
        case id, image, attachments, name
        case shortDesc = "short_desc"
        case location, delivery, distance, rate, minuim
        case closesAt = "closes_at"
        case offers
    }
}

struct StoreOffers: Codable {
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

// MARK: - Clinic
struct Clinic: Codable {
    var id: Int?
    var image: String?
    var attachments: [Attachements]?
    var name, shortDesc, location, delivery: String?
    var distance: String?
    var rate: Int?
    var minuim, closesAt: String?
    var offers: [ClinicOffer]?

    enum CodingKeys: String, CodingKey {
        case id, image, attachments, name
        case shortDesc = "short_desc"
        case location, delivery, distance, rate, minuim
        case closesAt = "closes_at"
        case offers
    }
}

// MARK: - ClinicOffer
struct ClinicOffer: Codable {
    var id, merchantID: Int?
    var name: String?
    var desc: String?
    var rate: Int?
    var price, oldPrice, discountPercentage: Int?
    var animalsNumber: Int?
    var services: [Service]?

    enum CodingKeys: String, CodingKey {
        case id
        case merchantID = "merchant_id"
        case name, desc, rate, price
        case oldPrice = "old_price"
        case discountPercentage = "discount_percentage"
        case animalsNumber = "animals_number"
        case services
    }
}
