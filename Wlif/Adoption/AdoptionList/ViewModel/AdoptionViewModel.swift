//
//  AdoptionViewModel.swift
//  Wlif
//
//  Created by OSX on 13/07/2025.
//

import Foundation

class AdoptionViewModel {
    
    var isLoading: Observable<Bool> = Observable(false)
    
    var adoptionList: AdoptionModel? {
        didSet {
            self.onAdoptionListFetched?(adoptionList)
        }
    }
    
    var onAdoptionListFetched: ((AdoptionModel?) -> Void)?
    
    func getAdoptions(completion: ((Result<AdoptionModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true
        NetworkManager.instance.request(Urls.adoptionList, parameters: nil, method: .get, type: AdoptionModel.self) { [weak self] (baseModel, error) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.adoptionList = data
            }
        }
    }
}
