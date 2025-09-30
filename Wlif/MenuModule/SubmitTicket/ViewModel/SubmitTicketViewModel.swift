//
//  SubmitTicketViewModel.swift
//  Wlif
//
//  Created by OSX on 10/08/2025.
//

import Foundation

class SubmitTicketViewModel {
    
    var isLoading: Observable<Bool> = Observable(false)
    
    func submitTicket(name: String, email: String, comment: String, completion: ((Result<SupportModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true

        let params = [
            "name": name,
            "email": email,
            "comment": comment
        ] as [String: Any]
        
        
        NetworkManager.instance.request(Urls.addTicket, parameters: params, method: .post, type: SupportModel.self) { [weak self] (baseModel, message) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                completion?(.success(data))
            } else {
                completion?(.failure(ErrorHelper.makeError(message ?? "")))
            }

        }
    }
}
