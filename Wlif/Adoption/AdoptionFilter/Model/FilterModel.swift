//
//  FilterModel.swift
//  Wlif
//
//  Created by OSX on 18/07/2025.
//

import Foundation

struct FilterModel {
    var imageBlack: String?
    var image: String
    var title: String?
}

struct MyAnimalModel: Codable {
    var id: Int?
    var image: String?
    var petName: String?
    var description: String?
    var distance: String?
    var adopted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, image
        case petName = "pet_name"
        case description, distance, adopted
    }
}
