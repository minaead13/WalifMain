//
//  ServiceDetailsModel.swift
//  Wlif
//
//  Created by OSX on 07/07/2025.
//

import Foundation

struct StoreModel: Codable {
    var store: Store?
    var categories: [StoreCategory]?
    var products: [Product]?
}

struct StoreCategory: Codable {
    var id: Int?
    var name: String?
    var image: String?
    var slogan: String?
}

struct Store: Codable {
    var id: Int?
    var image: String?
    var name: String?
    var shortDesc: String?
    var delivery: String?
    var distance: String?
    var rate: Int?
    var minuim: String?
    var closesAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, image, name
        case shortDesc = "short_desc"
        case delivery, distance, rate, minuim
        case closesAt = "closes_at"
    }
}

struct Product: Codable {
    var id: Int?
    var image: String?
    var name: String?
    var priceBefore, price: Int?
    var desc: String?
    var sizes: [Size]?
    var colors: [Color]?
    
    enum CodingKeys: String, CodingKey {
        case id, image, name
        case priceBefore = "price_before"
        case price, desc, sizes, colors
    }
}
