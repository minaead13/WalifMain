//
//  ServiceDetailsViewModel.swift
//  Wlif
//
//  Created by OSX on 21/07/2025.
//

import Foundation

class ServiceDetailsViewModel {
    var id: Int?
    var title: String?
    var store: Store?
    var isLoading: Observable<Bool> = Observable(false)
    
    var serviceDetails: ServiceDetails? {
        didSet {
            self.onServiceDetailsFetched?(serviceDetails)
        }
    }
    
    var onServiceDetailsFetched: ((ServiceDetails?) -> Void)?
    
    func getServiceDetails(completion: ((Result<[ServiceDetails], Error>) -> Void)? = nil) {
        self.isLoading.value = true

        let url = Urls.service + "/\(id ?? 0)"
        NetworkManager.instance.request(url, parameters: nil, method: .get, type: ServiceDetails.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                self?.serviceDetails = data
            }
        }
    }
}


