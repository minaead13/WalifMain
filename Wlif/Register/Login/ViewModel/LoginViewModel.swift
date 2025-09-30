//
//  LoginViewModel.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import Foundation

class LoginViewModel {
    
    var userData: User?
    private let validator: LoginValidatorProtocol
    var isLoading: Observable<Bool> = Observable(false)
    
    init(validator: LoginValidatorProtocol) {
        self.validator = validator
    }
    
    func processLogin(mobileNumber: String, completion:  @escaping (Result<UserModel, Error>) -> Void) {
        
        guard validator.ismobileNumberValid(mobileNumber) else {
            completion(.failure(ErrorHelper.makeError("Not valid number")))
            return
        }
        
        let params = ["phone" : "966\(mobileNumber)"]
        self.isLoading.value = true
        NetworkManager.instance.request(Urls.login, parameters: params, method: .post, type: UserModel.self) { [weak self] (baseModel, message) in
            self?.isLoading.value = false
            if let data = baseModel?.data {
                self?.userData = data.user
                completion(.success(data))
            } else {
                completion(.failure(ErrorHelper.makeError(message ?? "Not valid number")))
            }
        }
    }
    
    func verify(phone: String ,enteredCode:Int, code: Int, completion:  @escaping (Result<UserModel, Error>) -> Void) {
        
        guard validator.isCodeValid(enteredCode: enteredCode, expectedCode: code) else {
            completion(.failure(ErrorHelper.makeError("Not valid number".localized)))
            return
        }
        self.isLoading.value = true
        let parameters = [
            "phone": phone,
            "code": code,
            "mac_id": NetworkManager.getDeviceId(),
            "device_token": NetworkManager.getDeviceId(),
        ] as [String: Any]
        
        NetworkManager.instance.request(Urls.verifyOTP, parameters: parameters, method: .post, type: UserModel.self) { [weak self] (baseModel, message) in
            self?.isLoading.value = false
            if let data = baseModel?.data {
                UserUtil.save(data)
                completion(.success(data))
            } else {
                completion(.failure(ErrorHelper.makeError(message ?? "Unknown error".localized)))
            }
        }
    }
}
