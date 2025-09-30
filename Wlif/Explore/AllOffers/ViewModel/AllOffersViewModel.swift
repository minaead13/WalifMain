//
//  AllOffersViewModel.swift
//  Wlif
//
//  Created by OSX on 14/08/2025.
//

import Foundation

class AllOffersViewModel {
    
    var serviceSolgan: String?
    var offersType: SectionType = .store
    
    var isLoading: Observable<Bool> = Observable(false)

    var storeOffers: [StoreOffer]? {
        didSet {
            self.onAllOffersFetched?()
        }
    }

    var onAllOffersFetched: (() -> Void)?
    
     func fetchOffers() {
        isLoading.value = true
        let params = ["service_slogan": serviceSolgan ?? ""]
        
        NetworkManager.instance.request(Urls.exploreViewAll,
                                        parameters: params,
                                        method: .get,
                                        type: [StoreOffer].self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.storeOffers = data
            }
        }
    }
    
    func setTitle() -> String {
        switch offersType {
        case .store:
            return "Stores".localized
        case .clinic:
            return "Clinics".localized
        case .hotel:
            return "Hotels".localized
        }
    }
}
