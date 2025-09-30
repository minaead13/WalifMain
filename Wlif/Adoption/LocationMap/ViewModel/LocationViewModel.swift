//
//  LocationViewModel.swift
//  Fleen
//
//  Created by Mina Eid on 07/02/2024.
//

import UIKit

class LocationViewModel{
    
    var lon: Float?
    var lat: Float?
    var address: String?
    var saved: Int = 1
    var addressType: String = "1"
    
    var completionHandler: (() -> Void)?
    var isLoading: Observable<Bool> = Observable(false)

    func addAddress(completion: ((Result<AdoptionModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true

        var parameters: [String: Any] = [
            "lat": lat ?? 0,
            "lon": lon ?? 0,
            "address_type": addressType,
            "address": address ?? ""
        ]
        
        if saved == 1 {
            parameters["saved"] = "1"
        }
        
        NetworkManager.instance.request(Urls.addressStore, parameters: parameters, method: .post, type: AdoptionModel.self) { [weak self] (baseModel, error) in
            guard let self else { return }
            isLoading.value = false

            if let data = baseModel?.data {
                completionHandler?()
                
                let address = AddressModel(address: address, lat: "\(lat ?? 0)", lon: "\(lon ?? 0)", addressType: Int(addressType))
                
                LocationUtil.save(address)
                completion?(.success(data))
            }
        }
    }
    
}
