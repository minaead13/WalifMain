//
//  TermsViewModel.swift
//  Wlif
//
//  Created by OSX on 06/08/2025.
//

import Foundation

class TermsViewModel {
    var isLoading: Observable<Bool> = Observable(false)
    
    var terms: TermsModel? {
        didSet {
            self.onTermsFetched?(terms)
        }
    }
    
    var onTermsFetched: ((TermsModel?) -> Void)?
    
    func getTerms(completion: ((Result<TermsModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true
        
        
        NetworkManager.instance.request(Urls.terms, parameters: nil, method: .get, type: TermsModel.self) { [weak self] (baseModel, error) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.terms = data
            }
        }
    }
}
