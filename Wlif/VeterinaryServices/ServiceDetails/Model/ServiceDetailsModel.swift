//
//  ServiceDetailsModel.swift
//  Wlif
//
//  Created by OSX on 21/07/2025.
//

import Foundation

struct ServiceDetails: Codable {
    var service: Service?
    var categories: [Category]?
}

struct Category: Codable {
    var id: Int?
    var name: String?
    var desc: String?
    var rate: Int?
    var price: Int?
}
