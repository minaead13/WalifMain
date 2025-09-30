//
//  PetsStoreConfirmOrderViewModel.swift
//  Wlif
//
//  Created by OSX on 03/08/2025.
//

import Foundation
import MoyasarSdk

class PetsStoreConfirmOrderViewModel {
//    var cart: CartModel?
    var deliveryFees: DeliveryModel?
    var lon: String?
    var lat: String?
    var address: String?
    var payment: ApiPayment?
    var selectedMethod: PaymentMethod = .online
    var isLoading: Observable<Bool> = Observable(false)
    
    var order: CartItems? {
        didSet {
            self.onOrderConfirmed?(order)
        }
    }
        
    var onOrderConfirmed: ((CartItems?) -> Void)?
    
    var cart: CartModel? {
        didSet {
            self.onCartFetched?(cart)
        }
    }
    
    var onCartFetched: ((CartModel?) -> Void)?
    
    func addStoreOrder(completion: ((Result<CartItems, Error>) -> Void)? = nil) {
        self.isLoading.value = true

        var params = [
            "lat": "\(LocationUtil.load()?.lat ?? "")",
            "lon": "\(LocationUtil.load()?.lat ?? "")",
            "address_name": "\(LocationUtil.load()?.address ?? "")",
            "payment_type": selectedMethod == .online ? "3" : "2",
        ] as [String: Any]
        
        if selectedMethod == .online {
            params[ "payment_gatway"] = "moyasser"
        }
        
                
        NetworkManager.instance.request(Urls.storeOrder, parameters: params, method: .post, type: CartItems.self) { [weak self] (baseModel, message) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                self?.order = data
                completion?(.success(data))
            } else {
                completion?(.failure(ErrorHelper.makeError(message ?? "Unknown error")))
            }
        }
    }
    
    func getCart(completion: ((Result<CartModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true
        NetworkManager.instance.request(Urls.cart, parameters: nil, method: .get, type: CartModel.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false
            if let data = baseModel?.data {
                self?.cart = data
            }
        }
    }
    
    func getDeliveryFees(completion: ((Result<DeliveryModel, Error>) -> Void)? = nil) {

        let params = [
            "merchant_id": "\(cart?.items?.first?.merchantId ?? 0)",
            "lat": "\(LocationUtil.load()?.lat ?? "")",
            "lon": "\(LocationUtil.load()?.lon ?? "")"
        ] as [String: Any]
        
        NetworkManager.instance.request(Urls.deliveryFees, parameters: params, method: .post, type: DeliveryModel.self) { [weak self] (baseModel, message) in

            if let data = baseModel?.data {
                self?.deliveryFees = data
                self?.getCart()
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
        
        let url = Urls.payment + "/\(cart?.items?.first?.merchantId ?? 0))"
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
