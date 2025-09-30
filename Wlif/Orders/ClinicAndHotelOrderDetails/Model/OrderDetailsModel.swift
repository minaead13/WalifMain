//
//  OrderDetailsModel.swift
//  Wlif
//
//  Created by OSX on 03/09/2025.
//

import Foundation

// MARK: - OrderDetailsModel
struct OrderDetailsModel: Codable {
    var id: Int?
    var orderNumber: String?
    var merchantID: Int?
    var merchantImage: String?
    var merchantName: String?
    var merchantRate: Int?
    var serviceType, serviceDate, serviceTime: String?
    var animalTypes: [AnimalType]?
    var startDate, endDate: String?
    var animalsNumber, roomsNumber: Int?
    var services: [AnimalType]?
    var status: String?
    var statusValue: Int?
    var paymentType: String?
    var paymentGatway: String?
    var deliveryValue, subtotal, tax, total: String?
    var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNumber = "order_number"
        case merchantID = "merchant_id"
        case merchantImage = "merchant_image"
        case merchantName = "merchant_name"
        case merchantRate = "merchant_rate"
        case serviceType = "service_type"
        case serviceDate = "service_date"
        case serviceTime = "service_time"
        case animalTypes = "animal_types"
        case startDate = "start_date"
        case endDate = "end_date"
        case animalsNumber = "animals_number"
        case roomsNumber = "rooms_number"
        case services, status
        case statusValue = "status_value"
        case paymentType = "payment_type"
        case paymentGatway = "payment_gatway"
        case deliveryValue = "delivery_value"
        case subtotal, tax, total
        case createdAt = "created_at"
    }
}
