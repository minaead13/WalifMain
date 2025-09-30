//
//  AdoptionModel.swift
//  Wlif
//
//  Created by OSX on 13/07/2025.
//

import Foundation

struct AdoptionModel: Codable {
    var data: [AdoptionData]?
    var banners: [BannerModel]?
 
}

struct AdoptionData: Codable {
    var id: Int?
    var image: String?
    var petName: String?
    var description: String?
    var distance: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case image
        case petName = "pet_name"
        case description
        case distance
    }
}
