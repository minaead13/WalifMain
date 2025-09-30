//
//  ClinicAndHotelOrderDetailsViewModel.swift
//  Wlif
//
//  Created by OSX on 03/09/2025.
//

import Foundation

class ClinicAndHotelOrderDetailsViewModel {
    var id: Int?
    var isLoading: Observable<Bool> = Observable(false)
    var slogan: Services?
    
    var orderDetails: OrderDetailsModel? {
        didSet {
            self.onOrderDetailsFetched?(orderDetails)
        }
    }
    
    var onOrderDetailsFetched: ((OrderDetailsModel?) -> Void)?
    
    func getOrderDetails() {
        self.isLoading.value = true
        let url = Urls.bookingOrder + "/\(id ?? 0)"
        NetworkManager.instance.request(url, parameters: nil, method: .get, type: OrderDetailsModel.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                self?.orderDetails = data
            }
        }
    }
}
