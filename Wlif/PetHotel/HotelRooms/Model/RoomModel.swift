//
//  RoomModel.swift
//  Wlif
//
//  Created by OSX on 30/07/2025.
//

import Foundation

struct RoomModel: Codable {
    var id: Int?
    var name: String?
    var animalsNumber, price: Int?
    var services: [Service]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case animalsNumber = "animals_number"
        case price, services
    }
}
