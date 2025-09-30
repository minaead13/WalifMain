//
//  CartViewModel.swift
//  Wlif
//
//  Created by OSX on 09/07/2025.
//

import Foundation

class CartViewModel {
    
    var isLoading: Observable<Bool> = Observable(false)

    var cart: CartModel? {
        didSet {
            self.onCartFetched?(cart)
        }
    }
    
    var onCartFetched: ((CartModel?) -> Void)?
    
    var deliveryFees: DeliveryModel? {
        didSet {
            self.onDeliveryFeesFetched?(deliveryFees)
        }
    }
    
    var onDeliveryFeesFetched: ((DeliveryModel?) -> Void)?
    
    func addCartProduct(productId: Int, qty: Int, completion: ((Result<StoreModel, Error>) -> Void)? = nil) {
        
        self.isLoading.value = true

        let params = [
            "product_id" : productId,
            "qty": qty
        ] as [String: Any]
        
        NetworkManager.instance.request(Urls.storeCart, parameters: params, method: .post, type: StoreModel.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                self?.getCart()
                completion?(.success(data))
            } else {
                completion?(.failure(ErrorHelper.makeError(error ?? "Unknown error")))
            }
        }
    }
    
    func minusCartProduct(itemId: Int, productId: Int, qty: Int, completion: ((Result<StoreModel, Error>) -> Void)? = nil) {
        
        let url = Urls.cartUpdate + "/\(itemId)"
        let params = [
            "qty": qty
        ] as [String: Any]
        
        NetworkManager.instance.request(url, parameters: params, method: .post, type: StoreModel.self) { [weak self] (baseModel, error) in
            if let data = baseModel?.data {
                self?.getCart()
                completion?(.success(data))
            } else {
                completion?(.failure(ErrorHelper.makeError(error ?? "Unknown error")))
            }
        }
    }
    
    func getCart(completion: ((Result<CartModel, Error>) -> Void)? = nil) {
                
        NetworkManager.instance.request(Urls.cart, parameters: nil, method: .get, type: CartModel.self) { [weak self] (baseModel, error) in
            if let data = baseModel?.data {
                self?.cart = data
            }
        }
    }
    
    func getDeliveryFees(completion: ((Result<DeliveryModel, Error>) -> Void)? = nil) {

        let params = [
            "merchant_id": "1",
            "lat": "\(LocationUtil.load()?.lat ?? "")",
            "lon": "\(LocationUtil.load()?.lon ?? "")"
        ] as [String: Any]
        
        NetworkManager.instance.request(Urls.deliveryFees, parameters: params, method: .post, type: DeliveryModel.self) { [weak self] (baseModel, message) in

            if let data = baseModel?.data {
                self?.deliveryFees = data
            }
        }
    }
    
    func deleteItem(itemId: Int, completion: ((Result<CartModel, Error>) -> Void)? = nil) {
               
        let url = Urls.deleteItem + "/\(itemId)"
        NetworkManager.instance.request(url, parameters: nil, method: .get, type: CartModel.self) { [weak self] (baseModel, error) in
            if let data = baseModel?.data {
                self?.cart = data
            }
        }
    }
}
