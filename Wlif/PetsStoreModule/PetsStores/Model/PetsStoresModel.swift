//
//  PetsStoresModel.swift
//  Wlif
//
//  Created by OSX on 07/07/2025.
//

import Foundation

struct PetsStoresDataContainer: Codable {
    var data: [PetsStoresModel]?
    var banners: [BannerModel]?
}

struct PetsStoresModel: Codable {
    var id: Int?
    var image: String?
    var name, shortDesc, delivery, distance: String?
    var rate: Int?
    var minuim, closesAt: String?

    enum CodingKeys: String, CodingKey {
        case id, image, name
        case shortDesc = "short_desc"
        case delivery, distance, rate, minuim
        case closesAt = "closes_at"
    }
}

struct BannerModel: Codable {
    var id: Int?
    var image: String?
}
