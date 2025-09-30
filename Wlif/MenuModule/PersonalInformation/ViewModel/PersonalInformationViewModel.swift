//
//  PersonalInformationViewModel.swift
//  Wlif
//
//  Created by OSX on 06/08/2025.
//

import UIKit

class PersonalInformationViewModel {
    var userImage: [UIImage]?
    
    private let validator: LoginValidatorProtocol
    
    init(validator: LoginValidatorProtocol) {
        self.validator = validator
    }
    
    var isLoading: Observable<Bool> = Observable(false)
    
    var user: UserModel? {
        didSet {
            self.onUserDetailsFetched?(user)
        }
    }
    
    var onUserDetailsFetched: ((UserModel?) -> Void)?
    
    func getUserDetails(completion: ((Result<UserModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true
        
        
        NetworkManager.instance.request(Urls.profile, parameters: nil, method: .get, type: UserModel.self) { [weak self] (baseModel, error) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.user = data
            }
        }
    }
    
    func editProfile(name: String, email: String, completion: ((Result<UserModel, Error>) -> Void)? = nil) {
        
        guard validator.isFullNameValid(name) && validator.isEmailValid(email) else {
            completion?(.failure(ErrorHelper.makeError("Not valid data")))
            return
        }
        self.isLoading.value = true

        let params = [
            "name": name,
            "email": email
        ] as [String: Any]
        
        
        NetworkManager.instance.upload(Urls.editProfile, parameters: params, method: .post, type: UserModel.self, images: userImage ?? [], fileName: "", fileExt: "") { [weak self] (baseModel, message) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
               completion?(.success(data))
            } else {
                completion?(.failure(ErrorHelper.makeError(message ?? "Unknown error")))
            }
        }
    }
}
