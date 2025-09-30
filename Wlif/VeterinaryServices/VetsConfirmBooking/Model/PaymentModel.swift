//
//  PaymentModel.swift
//  Wlif
//
//  Created by Mina Eid on 22/09/2025.
//

import Foundation

struct PaymentModel: Codable {
    var orderId: Int?
    var orderSlogan: String?
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case orderSlogan = "order_slogan"
    }
}
