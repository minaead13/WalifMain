//
//  HotelDetailsViewModel.swift
//  Wlif
//
//  Created by OSX on 28/07/2025.
//

import Foundation

class HotelDetailsViewModel {
    
    var id: Int?
    var isLoading: Observable<Bool> = Observable(false)
    
    var petHotelDetails: HotelDetailsModel? {
        didSet {
            self.onPetHotelDetailsFetched?(petHotelDetails)
        }
    }
    
    var onPetHotelDetailsFetched: ((HotelDetailsModel?) -> Void)?
    
    var petHotelReviews: [HotelReview]? {
        didSet {
            self.onPetHotelReviewsFetched?(petHotelReviews)
        }
    }
    
    var onPetHotelReviewsFetched: (([HotelReview]?) -> Void)?
    
    func getPetHotelDetails(completion: ((Result<HotelDetailsModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true
        
        let url = Urls.store + "/\(id ?? 0)"
        
        NetworkManager.instance.request(url, parameters: nil, method: .get, type: HotelDetailsModel.self) { [weak self] (baseModel, error) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.petHotelDetails = data
            }
        }
    }
    
    func getPetHotelReviews(completion: ((Result<[HotelReview], Error>) -> Void)? = nil) {
        self.isLoading.value = true
        
        let url = Urls.commentsList
        
        let parameters: [String: Any] = [
            "type": "Merchant",
            "id": "1"
                //id ?? 0
        ]
        
        NetworkManager.instance.request(url, parameters: parameters, method: .get, type: [HotelReview].self) { [weak self] (baseModel, error) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.petHotelReviews = data
            }
        }
    }
}
