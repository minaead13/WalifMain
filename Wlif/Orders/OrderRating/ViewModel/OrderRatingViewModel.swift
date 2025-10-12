//
//  OrderRatingViewModel.swift
//  Wlif
//
//  Created by Mina Lamey on 09/10/2025.
//

import Foundation

class OrderRatingViewModel {
    
    var orderID: Int?
    var rate: Int?
    var comment: String?
    var isFromStore: Bool = false
    var completionHandler: (() -> Void)?
    let placeholder = "Comment".localized
   
    var isLoading: Observable<Bool> = Observable(false)

    func addRateOrder(completion: ((Result<CreatedOrder, Error>) -> Void)? = nil) {
        self.isLoading.value = true

        let params = [
            "order_id": "\(orderID ?? 0)",
            "rate": "\(rate ?? 0)",
            "comment": "\(comment ?? "")",
            "type": isFromStore ? "order" : "booking_order"
        ] as [String: Any]
        
        NetworkManager.instance.request(Urls.addRate , parameters: params, method: .post, type: CreatedOrder.self) { [weak self] (baseModel, message) in
            self?.isLoading.value = false
            if let data = baseModel?.data {
                completion?(.success(data))
            } else {
                completion?(.failure(ErrorHelper.makeError(message ?? "Unknown error")))
            }
        }
    }
}
