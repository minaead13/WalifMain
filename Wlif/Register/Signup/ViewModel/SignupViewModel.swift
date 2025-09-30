//
//  SignupViewModel.swift
//  Wlif
//
//  Created by OSX on 02/07/2025.
//

import Foundation

class SignupViewModel {
    
    let validator: LoginValidatorProtocol
    var isLoading: Observable<Bool> = Observable(false)
    
    init(validator: LoginValidatorProtocol) {
        self.validator = validator
    }
    
    func register(fullName: String, phone: String, email: String, completion:  @escaping (Result<UserModel, Error>) -> Void){
        guard validator.isFullNameValid(fullName) && validator.ismobileNumberValid(phone) && validator.isEmailValid(email)  else {
            completion(.failure(ErrorHelper.makeError("Not valid data".localized)))
            return
        }
        self.isLoading.value = true
        let parameters = [
            "name": fullName,
            "phone": "966\(phone)",
            "email": email
        ] as [String: Any]
        
        NetworkManager.instance.request(Urls.register, parameters: parameters, method: .post, type: UserModel.self) { [weak self] (baseModel, message) in
            self?.isLoading.value = false
            if let data = baseModel?.data {
                completion(.success(data))
            } else {
                completion(.failure(ErrorHelper.makeError(message ?? "Unknown error".localized)))
            }
        }
    }
}
