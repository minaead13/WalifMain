//
//  OrderHistoryViewModel.swift
//  Wlif
//
//  Created by OSX on 02/09/2025.
//

import Foundation

class OrderHistoryViewModel {
    
    var filterArr = [
        FilterModel(imageBlack: "AllOrders.Black" ,image: "AllOrders", title: "All Orders".localized),
        FilterModel(imageBlack: "Book.Black"  ,image: "Book", title: "Book The Clinic".localized),
        FilterModel(imageBlack: "Book.Black" ,image: "Book", title: "Book The Hotel".localized),
        FilterModel(imageBlack: "Delivery Location.Black" ,image: "Delivery Location", title: "Delivery".localized),
    ]
    var selectedIndex: Int = 0
    var isLoading: Observable<Bool> = Observable(false)

    var orderHistory: OrderHistory? {
        didSet {
            self.onOrderHistoryFetched?(orderHistory)
        }
    }
    
    var onOrderHistoryFetched: ((OrderHistory?) -> Void)?
    
    var bookHistory: BookOrderHistory? {
        didSet {
            self.onBookOrderHistoryFetched?(bookHistory)
        }
    }
    
    var onBookOrderHistoryFetched: ((BookOrderHistory?) -> Void)?
    
    func getOrders() {
        self.isLoading.value = true
        NetworkManager.instance.request(Urls.orders, parameters: nil, method: .get, type: OrderHistory.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                self?.orderHistory = data
            }
        }
    }
    
    func getBookOrders(slogan: Services) {
        let params: [String: Any] = ["service_slogan": slogan.rawValue]
        self.isLoading.value = true
        NetworkManager.instance.request(Urls.orders, parameters: params, method: .get, type: BookOrderHistory.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                self?.bookHistory = data
            }
        }
    }
}
