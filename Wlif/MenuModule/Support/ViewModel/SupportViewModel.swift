//
//  SupportViewModel.swift
//  Wlif
//
//  Created by OSX on 07/08/2025.
//

import Foundation

class SupportViewModel {
    var isLoading: Observable<Bool> = Observable(false)
    
    var support: SupportModel? {
        didSet {
            self.onSupportFetched?(support)
        }
    }
    
    var onSupportFetched: ((SupportModel?) -> Void)?
    
    func getSupport(completion: ((Result<SupportModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true
        
        
        NetworkManager.instance.request(Urls.contactus, parameters: nil, method: .get, type: SupportModel.self) { [weak self] (baseModel, error) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.support = data
            }
        }
    }
}
