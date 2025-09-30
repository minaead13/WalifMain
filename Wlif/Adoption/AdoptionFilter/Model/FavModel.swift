//
//  FavModel.swift
//  Wlif
//
//  Created by OSX on 28/07/2025.
//

import Foundation

struct FavModel: Codable {
    var id: Int?
    var image: String?
    var petName: String?
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case image
        case petName = "pet_name"
        case description
    }
}
