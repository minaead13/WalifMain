//
//  StoreOrderDetailsViewModel.swift
//  Wlif
//
//  Created by OSX on 03/09/2025.
//

import Foundation

class StoreOrderDetailsViewModel {
    var id: Int?
    var isLoading: Observable<Bool> = Observable(false)
   
    
    var orderDetails: StoreOrderModel? {
        didSet {
            self.onOrderDetailsFetched?(orderDetails)
        }
    }
    
    var onOrderDetailsFetched: ((StoreOrderModel?) -> Void)?
    
    func getOrderDetails() {
        self.isLoading.value = true
        
        let url = Urls.order + "/\(id ?? 0)"
        
        NetworkManager.instance.request(url, parameters: nil, method: .get, type: StoreOrderModel.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                self?.orderDetails = data
            }
        }
    }
}
