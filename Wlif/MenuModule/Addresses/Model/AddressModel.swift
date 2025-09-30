//
//  AddressModel.swift
//  Wlif
//
//  Created by OSX on 11/08/2025.
//

import Foundation

struct AddressModel: Codable {
    var id: Int?
    var address, lat, lon, type: String?
    var addressType: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, address, lat, lon, type
        case addressType = "address_type"
    }
}
