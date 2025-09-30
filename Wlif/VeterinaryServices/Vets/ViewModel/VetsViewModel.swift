//
//  VetsViewModel.swift
//  Wlif
//
//  Created by OSX on 20/07/2025.
//

import Foundation

class VetsViewModel {
    var id: Int?
    var isLoading: Observable<Bool> = Observable(false)
    
    var vetsServices: VetsServicesModel? {
        didSet {
            self.onVetsServicesFetched?(vetsServices)
        }
    }
    
    var onVetsServicesFetched: ((VetsServicesModel?) -> Void)?
    
    func getVetsServices(completion: ((Result<VetsServicesModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true

        let url = Urls.store + "/\(id ?? 0)"
        NetworkManager.instance.request(url, parameters: nil, method: .get, type: VetsServicesModel.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                self?.vetsServices = data
            }
        }
    }
}
