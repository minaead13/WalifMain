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


struct CreatedOrder: Codable {
    var orderID: Int?
    var subtotal, tax, total: Double?
    var paymentType: Int?

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case subtotal, tax, total
        case paymentType = "payment_type"
    }
}
