//
//  AddressesViewModel.swift
//  Wlif
//
//  Created by OSX on 11/08/2025.
//

import Foundation

class AddressesViewModel {
   
    var isLoading: Observable<Bool> = Observable(false)
    
    var addresses: [AddressModel]? {
        didSet {
            self.onaddressesListFetched?(addresses)
        }
    }
    
    var onaddressesListFetched: (([AddressModel]?) -> Void)?
    
    func getaddresses(completion: ((Result<[AddressModel], Error>) -> Void)? = nil) {
        self.isLoading.value = true

        NetworkManager.instance.request(Urls.addresses, parameters: nil, method: .get, type: [AddressModel].self) { [weak self] (baseModel, error) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.addresses = data
            }
        }
    }
    
    
    func deleteAddress(id: Int, completion: ((Result<AddressModel, Error>) -> Void)? = nil) {

        let url = Urls.address + "/delete/\(id)"
        NetworkManager.instance.request(url, parameters: nil, method: .delete, type: AddressModel.self) { [weak self] (baseModel, error) in
                        
            if let data = baseModel?.data {
                self?.getaddresses()
            }
        }
    }
}
