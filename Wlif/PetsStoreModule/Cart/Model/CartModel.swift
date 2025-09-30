//
//  CartModel.swift
//  Wlif
//
//  Created by OSX on 10/07/2025.
//

import Foundation

struct CartModel: Codable {
    var items: [Item]?
    var subtotal, total: Double?
    var tax, deliveryValue: String?
    
    enum CodingKeys: String, CodingKey {
        case items, subtotal, tax, total
        case deliveryValue = "delivery_value"
    }
}

struct CartItems: Codable {
    var items: [Item]?
}

struct Item: Codable {
    var id, merchantId, productID: Int?
    var name, store: String?
    var image: String?
    var price: Int?
    var size: String?
    var qty: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case merchantId = "merchant_id"
        case productID = "product_id"
        case name, store, image, price, size, qty
    }
}
