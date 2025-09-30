//
//  FavoritesViewModel.swift
//  Wlif
//
//  Created by OSX on 10/08/2025.
//

import Foundation

class FavoritesViewModel {
    
    var isLoading: Observable<Bool> = Observable(false)
    
    var favPets: [FavModel]? {
        didSet {
            self.onFavAnimalListFetched?(favPets)
        }
    }
    
    var onFavAnimalListFetched: (([FavModel]?) -> Void)?
    
    func getFavPets(completion: ((Result<[FavModel], Error>) -> Void)? = nil) {
        self.isLoading.value = true

       
        NetworkManager.instance.request(Urls.favList, parameters: nil, method: .get, type: [FavModel].self) { [weak self] (baseModel, error) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.favPets = data
            }
        }
    }
    
}
