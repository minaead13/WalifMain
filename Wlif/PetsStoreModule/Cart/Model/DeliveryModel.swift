//
//  DeliveryModel.swift
//  Wlif
//
//  Created by OSX on 12/08/2025.
//

import Foundation

struct DeliveryModel: Codable {
    var cost: Int?
    var expectedDeliveryTime: String?
    
    enum CodingKeys: String, CodingKey {
        case cost
        case expectedDeliveryTime = "expected_delivery_time"
    }
}
