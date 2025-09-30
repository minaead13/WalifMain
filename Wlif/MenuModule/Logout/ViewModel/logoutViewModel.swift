//
//  logoutViewModel.swift
//  Wlif
//
//  Created by OSX on 10/08/2025.
//

import Foundation

class LogoutViewModel {
    var isDeleteAddress: Bool = false
    var completionHandler: (() -> Void)?
    var isLoading: Observable<Bool> = Observable(false)
    
    func logout(completion: ((Result<SupportModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true

        NetworkManager.instance.request(Urls.logout, parameters: nil, method: .get, type: SupportModel.self) { [weak self] (baseModel, message) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                UserUtil.remove()
                LocationUtil.delete()
                completion?(.success(data))
            } else {
                completion?(.failure(ErrorHelper.makeError(message ?? "")))
            }

        }
    }
}
