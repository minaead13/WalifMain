//
//  RoomViewModel.swift
//  Wlif
//
//  Created by OSX on 30/07/2025.
//

import Foundation

class RoomViewModel {
    
    var id: Int?
    var selectedIndex: Int?
    var isLoading: Observable<Bool> = Observable(false)
    var completionHandler: ((RoomModel) -> Void)?

    var rooms: [RoomModel]? {
        didSet {
            self.onRoomsListFetched?(rooms)
        }
    }
    
    var onRoomsListFetched: (([RoomModel]?) -> Void)?
    
    func getHotelRooms(completion: ((Result<[RoomModel], Error>) -> Void)? = nil) {
        self.isLoading.value = true
        
        let url = Urls.store + "/\(id ?? 0)/" + Urls.rooms
        
        NetworkManager.instance.request(url, parameters: nil, method: .get, type: [RoomModel].self) { [weak self] (baseModel, error) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.rooms = data
            }
        }
    }
}
