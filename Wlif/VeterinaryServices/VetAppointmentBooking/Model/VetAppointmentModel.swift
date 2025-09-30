//
//  VetAppointmentModel.swift
//  Wlif
//
//  Created by OSX on 21/07/2025.
//

import Foundation

struct VetAppointmentModel: Codable {
    var timeSlots: [TimeSlot]?
    var animalTypes: [AnimalType]?
    
    enum CodingKeys: String, CodingKey {
        case timeSlots = "time_slots"
        case animalTypes = "animal_types"
    }
}

// MARK: - AnimalType
struct AnimalType: Codable {
    var id: Int?
    var name: String?
}

// MARK: - TimeSlot
struct TimeSlot: Codable {
    var id: Int?
    var time: String?
}
