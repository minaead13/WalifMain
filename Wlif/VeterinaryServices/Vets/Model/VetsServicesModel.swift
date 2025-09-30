//
//  VetsServicesModel.swift
//  Wlif
//
//  Created by OSX on 20/07/2025.
//

import Foundation

struct VetsServicesModel: Codable {
    var store: Store?
    var services: [Service]?
}

struct Service: Codable {
    var id: Int?
    var name: String?
    var price: Int?
}
