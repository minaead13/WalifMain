//
//  PetsStoresViewModel.swift
//  Wlif
//
//  Created by OSX on 07/07/2025.
//

import Foundation

class PetsStoresViewModel {
    
    var serviceType: Services?
    var isLoading: Observable<Bool> = Observable(false)

    var petsStores: PetsStoresDataContainer? {
        didSet {
            self.onPetsStoresFetched?(petsStores)
        }
    }
    
    var onPetsStoresFetched: ((PetsStoresDataContainer?) -> Void)?
    
    func getPetsStores(completion: ((Result<PetsStoresDataContainer, Error>) -> Void)? = nil) {
        self.isLoading.value = true

        var url: String?
        if serviceType == .petStores {
            url = Urls.storesList
        } else if serviceType == .veterinaryServices {
            url = Urls.vetsService
        }
      
        NetworkManager.instance.request(url ?? "", parameters: nil, method: .get, type: PetsStoresDataContainer.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                self?.petsStores = data
            }
        }
    }
}
