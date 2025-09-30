//
//  HotelBookingViewModel.swift
//  Wlif
//
//  Created by OSX on 29/07/2025.
//

import Foundation

class HotelBookingViewModel {
    var id: Int?
    var services: [Service]?
    var selectedServices: [Service]?
    var store: PetHotel?
    var fromDate: String?
    var toDate: String?
    var noOfAnimals: String?
    var room: RoomModel?
}
