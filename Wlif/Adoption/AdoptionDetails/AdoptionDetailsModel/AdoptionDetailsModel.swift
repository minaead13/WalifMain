//
//  AdoptionDetailsModel.swift
//  Wlif
//
//  Created by OSX on 13/07/2025.
//

import Foundation

struct AdoptionDetailsModel: Codable {
    var id: Int?
    var attachments: [String]?
    var petName, description, age, bloodType: String?
    var distance, phone: String?
    var location: String?
    var lat, lon: String?
    var isFav: Bool?
    var commentsCount: Int?
    var comments: [Comment]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case attachments
        case petName = "pet_name"
        case description, age
        case bloodType = "blood_type"
        case isFav = "is_favourited"
        case distance, phone, location, lat, lon, commentsCount, comments
    }
}

struct Comment: Codable {
    var id: Int?
    var name: String?
    var comment: String?
    var repliesCount: Int?
    var replies: [Reply]?
    var date: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, comment
        case repliesCount = "replies_count"
        case replies
        case date
    }
}

struct Reply: Codable {
    var id: Int?
    var image: String?
    var name: String?
    var comment: String?
    var date: String?
}
