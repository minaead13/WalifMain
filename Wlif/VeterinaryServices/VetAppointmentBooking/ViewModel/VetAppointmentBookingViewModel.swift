//
//  VetAppointmentBooking.swift
//  Wlif
//
//  Created by OSX on 21/07/2025.
//

import Foundation

class VetAppointmentBookingViewModel {
    var title: String?
    var serviceType: String?
    var selectedAnimalTypes: [AnimalType] = []
    var selectedTime: TimeSlot?
    var date: String?
    var store: Store?
    var storeID: Int?
    var category: Category?
    var isLoading: Observable<Bool> = Observable(false)
    
    var categoryDetails: VetAppointmentModel? {
        didSet {
            self.onCategoryDetailsFetched?(categoryDetails)
        }
    }
    
    var onCategoryDetailsFetched: ((VetAppointmentModel?) -> Void)?
    
    func getCategoryDetails(completion: ((Result<VetAppointmentModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true

        let url = Urls.category + "/\(category?.id ?? 0)"
        NetworkManager.instance.request(url, parameters: nil, method: .get, type: VetAppointmentModel.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false
                        
            if let data = baseModel?.data {
                self?.categoryDetails = data
            }
        }
    }
}
