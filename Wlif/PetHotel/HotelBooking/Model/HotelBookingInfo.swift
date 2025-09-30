//
//  HotelBookingInfo.swift
//  Wlif
//
//  Created by OSX on 31/07/2025.
//

import Foundation

struct HotelBookingInfo {
    var hotelId: Int?
    var fromDate: String?
    var toDate: String?
    var noOfAnimals: String?
    var room: RoomModel?
    var services: [Service]?
    var store: PetHotel?
}
