//
//  HomeViewModel.swift
//  Wlif
//
//  Created by OSX on 03/07/2025.
//

import Foundation

class HomeViewModel {
    
    var isLoading: Observable<Bool> = Observable(false)

    var homeData: HomeModel? {
        didSet {
            self.onServicesFetched?(homeData)
        }
    }
    
    var onServicesFetched: ((HomeModel?) -> Void)?
    
    func getServices() {
        self.isLoading.value = true
        NetworkManager.instance.request(Urls.home, parameters: nil, method: .get, type: HomeModel.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                self?.homeData = data
            }
        }
    }
}
