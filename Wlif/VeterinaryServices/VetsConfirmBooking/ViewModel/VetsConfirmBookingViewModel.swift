//
//  VetsConfirmBookingViewModel.swift
//  Wlif
//
//  Created by OSX on 23/07/2025.
//

import Foundation
import MoyasarSdk

class VetsConfirmBookingViewModel {
    
    var store: Store?
    var selectedAnimalTypes: [AnimalType] = []
    var selectedTime: TimeSlot?
    var serviceType: String?
    var date: String?
    var category: Category?
    var storeID: Int?
    var payment: ApiPayment?
    var selectedMethod: PaymentMethod = .online
    var isLoading: Observable<Bool> = Observable(false)

    func addVetOrder(completion: ((Result<VetAppointmentModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true

        var params = [
            "merchant_id": "\(storeID ?? 0)",
            "category_id": "\(category?.id ?? 0)",
            "date": "\(date?.toBackendDateFormat() ?? "")",
            "animal_types": selectedAnimalTypes.compactMap { $0.id },
            "time_slot_id": "\(selectedTime?.id ?? 0)",
            "payment_type": selectedMethod == .online ? "3" : "2",
        ] as [String: Any]
        
        if selectedMethod == .online {
            params[ "payment_gatway"] = "moyasser"
        }
                
        NetworkManager.instance.request(Urls.bookingStore, parameters: params, method: .post, type: VetAppointmentModel.self) { [weak self] (baseModel, message) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                completion?(.success(data))
            } else {
                completion?(.failure(ErrorHelper.makeError(message ?? "Unknown error")))
            }
        }
    }
    
    func addpayment(status: String, completion: ((Result<PaymentModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true
        
        var payloadString = ""
        if let jsonData = try? JSONEncoder().encode(payment),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            payloadString = jsonString
        }
        
        let params: [String: Any] = [
            "gateway": "moyassar",
            "transaction_id": "\(payment?.id ?? "0")",
            "payload": payloadString,
            "status": "\(status)"
        ] as [String: Any]
        
        let url = Urls.payment + "/\(storeID ?? 0)"
        NetworkManager.instance.request(url, parameters: params, method: .post, type: PaymentModel.self) { [weak self] (baseModel, message) in
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                completion?(.success(data))
            } else {
                completion?(.failure(ErrorHelper.makeError(message ?? "Unknown error")))
            }
        }
    }
}
