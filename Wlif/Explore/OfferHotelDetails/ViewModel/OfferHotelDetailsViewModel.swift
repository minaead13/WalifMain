//
//  OfferHotelDetailsViewModel.swift
//  Wlif
//
//  Created by OSX on 20/08/2025.
//

import Foundation

class OfferHotelDetailsViewModel {
    var hotel: Clinic?
    var fromViewAll = true
    var storeOffersDetails: StoreOffer?
    
    var isLoading: Observable<Bool> = Observable(false)
    
    var hotelsOffers: [OfferHotelDetailsModel]? {
        didSet {
            self.onOffersFetched?()
        }
    }
    
    var onOffersFetched: (() -> Void)?
    
    func fetchOffers() {
        isLoading.value = true
        let id = fromViewAll ? (storeOffersDetails?.id ?? 0) : (hotel?.id ?? 0)
        let url = Urls.exploreShow + "/\(id)"
        let params = ["service_slogan": "petHotel"]
        
        NetworkManager.instance.request(url,
                                        parameters: params,
                                        method: .get,
                                        type: [OfferHotelDetailsModel].self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.hotelsOffers = data
            }
        }
    }
}
