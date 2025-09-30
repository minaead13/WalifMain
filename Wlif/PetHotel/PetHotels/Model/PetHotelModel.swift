//
//  PetHotelModel.swift
//  Wlif
//
//  Created by OSX on 24/07/2025.
//

import Foundation

struct PetHotelModel: Codable {
    var data: [PetHotel]?
    var banners: [BannerModel]?
}

struct PetHotel: Codable {
    var id: Int?
    var image: String?
    var attachments: [Attachements]?
    var name, shortDesc, location, delivery: String?
    var distance: String?
    var rate: Int?
    var minuim, closesAt: String?

       enum CodingKeys: String, CodingKey {
           case id, image, name, attachments
           case shortDesc = "short_desc"
           case location, delivery, distance, rate, minuim
           case closesAt = "closes_at"
       }
}

struct Attachements: Codable {
    var id: Int?
    var image: String?
}
