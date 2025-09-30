//
//  OfferStoresDetailsViewModel.swift
//  Wlif
//
//  Created by OSX on 17/08/2025.
//

import Foundation

class OfferStoresDetailsViewModel {
    
    var storeOffersDetails: StoreOffer?
    
    var isLoading: Observable<Bool> = Observable(false)
    
    var storeOffers: [OfferStoresDetailsModel]? {
        didSet {
            self.onStoreOffersFetched?()
        }
    }
    
    var onStoreOffersFetched: (() -> Void)?
    
    func fetchOffers() {
        isLoading.value = true
        let url = Urls.exploreShow + "/\(storeOffersDetails?.id ?? 0)"
        let params = ["service_slogan": "petStores"]
        
        NetworkManager.instance.request(url,
                                        parameters: params,
                                        method: .get,
                                        type: [OfferStoresDetailsModel].self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.storeOffers = data
            }
        }
    }
}
