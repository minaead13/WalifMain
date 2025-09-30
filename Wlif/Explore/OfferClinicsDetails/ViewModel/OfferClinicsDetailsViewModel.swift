//
//  OfferClinicsDetailsViewModel.swift
//  Wlif
//
//  Created by OSX on 18/08/2025.
//

import Foundation

class OfferClinicsDetailsViewModel {
    var clinic: Clinic?
    var fromViewAll = true
    var storeOffersDetails: StoreOffer?
    
    var isLoading: Observable<Bool> = Observable(false)
    
    var vetsOffers: [OfferVeterinaryServicesDetailsModel]? {
        didSet {
            self.onVetsOffersFetched?()
        }
    }
    
    var onVetsOffersFetched: (() -> Void)?
    
    func fetchOffers() {
        isLoading.value = true
        let id = fromViewAll ? (storeOffersDetails?.id ?? 0) : (clinic?.id ?? 0)
        let url = Urls.exploreShow + "/\(id)"
        let params = ["service_slogan": "veterinaryServices"]
        
        NetworkManager.instance.request(url,
                                        parameters: params,
                                        method: .get,
                                        type: [OfferVeterinaryServicesDetailsModel].self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.vetsOffers = data
            }
        }
    }
}
