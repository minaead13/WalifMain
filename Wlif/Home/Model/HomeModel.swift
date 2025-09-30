//
//  HomeModel.swift
//  Wlif
//
//  Created by OSX on 03/07/2025.
//

import Foundation

struct HomeModel: Codable {
    var banners: [BannerModel]?
    var services: [HomeService]?
    var explore: [BannerModel]?
    var adoptionOffers: [AdoptionOffer]?
    
    enum CodingKeys: String, CodingKey {
        case banners, services, explore
        case adoptionOffers = "adoption_offers"
    }
}

// MARK: - AdoptionOffer
struct AdoptionOffer: Codable {
    let id: Int
    let image: String?
    let petName, description: String
    let imagesCount: Int

    enum CodingKeys: String, CodingKey {
        case id, image
        case petName = "pet_name"
        case description
        case imagesCount = "images_count"
    }
}

// MARK: - HomeService
struct HomeService: Codable {
    var id: Int?
    var name: String?
    var image: String?
    var slogan: String?
}

