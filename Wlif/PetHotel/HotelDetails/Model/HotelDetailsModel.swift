//
//  HotelDetailsModel.swift
//  Wlif
//
//  Created by OSX on 28/07/2025.
//

import Foundation

struct HotelDetailsModel: Codable {
    var store: PetHotel?
    var services: [Service]?
}

// MARK: - HotelReview
struct HotelReview: Codable {
    var id: Int?
    var image: String?
    var name: String?
    var rate: Int?
    var comment, date: String?
    var repliesCount: Int?
    var replies: [Reply]?

    enum CodingKeys: String, CodingKey {
        case id, image, name, rate, comment, date
        case repliesCount = "replies_count"
        case replies
    }
}
