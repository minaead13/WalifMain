//
//  PetHotelViewModel.swift
//  Wlif
//
//  Created by OSX on 24/07/2025.
//

import Foundation

class PetHotelViewModel {
    
    var isLoading: Observable<Bool> = Observable(false)
    
    var petHotel: PetHotelModel? {
        didSet {
            self.onPetHotelsFetched?(petHotel)
        }
    }
    
    var onPetHotelsFetched: ((PetHotelModel?) -> Void)?
    
    func getPetHotels(completion: ((Result<PetHotelModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true
        NetworkManager.instance.request(Urls.petHotels, parameters: nil, method: .get, type: PetHotelModel.self) { [weak self] (baseModel, error) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.petHotel = data
            }
        }
    }
}
