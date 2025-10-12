//
//  HotelConfirmBookingViewModel.swift
//  Wlif
//
//  Created by OSX on 31/07/2025.
//

import Foundation
import MoyasarSdk

class HotelConfirmBookingViewModel {
    var bookingInfo: HotelBookingInfo?
    var payment: ApiPayment?
    var selectedMethod: PaymentMethod = .online
    var isLoading: Observable<Bool> = Observable(false)
    var createdOrder: CreatedOrder?
    
    func confirmHotelBooking(completion: ((Result<CreatedOrder, Error>) -> Void)? = nil) {
        self.isLoading.value = true
        
        var params = [
            "merchant_id": "\(bookingInfo?.hotelId ?? 0)",
            "date": "\(bookingInfo?.fromDate ?? "")",
            "rooms_number": "\(bookingInfo?.room?.id ?? 0)",
            "animals_number": "\(bookingInfo?.noOfAnimals ?? "")",
            "category_ids": bookingInfo?.services?.compactMap { $0.id} ?? [],
            "payment_type": selectedMethod == .online ? "3" : "2",
        ] as [String: Any]
        
        if selectedMethod == .online {
            params[ "payment_gatway"] = "moyasser"
        }
        
        
        NetworkManager.instance.request(Urls.petHotelBooking, parameters: params, method: .post, type: CreatedOrder.self) { [weak self] (baseModel, message) in
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.createdOrder = data
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
        
        let url = Urls.payment + "/\(createdOrder?.orderID ?? 0)"
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
