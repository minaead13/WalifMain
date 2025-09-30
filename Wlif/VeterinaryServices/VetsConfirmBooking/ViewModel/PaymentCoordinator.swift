//
//  PaymentCoordinator.swift
//  Wlif
//
//  Created by Mina Eid on 22/09/2025.
//

import Foundation
import MoyasarSdk
import UIKit
import SwiftUI

final class PaymentCoordinator {
    
    static let shared = PaymentCoordinator()
    
    private init() {}
    
    func startPayment(
        from presenter: UIViewController,
        amount: Int,
        description: String? = nil,
        metadata: [String: MetadataValue] = [:],
        completion: @escaping (PaymentResult) -> Void
    ) {
        do {
            let request = try PaymentRequest(
                apiKey: "pk_test_rX2pYi2wsCi2TbqLeMKhUuhBk6crB4LMrRiYGSRu",
                amount: amount * 100,
                currency: "SAR",
                description: description,
                metadata: metadata,
                manual: false,
                saveCard: false,
                givenID: UUID().uuidString,
                allowedNetworks: [.mastercard, .visa, .mada],
                payButtonType: .pay
            )
            
            let creditCardView = CreditCardView(
                request: request,
                callback: completion
            )
            
            let hostingController = UIHostingController(rootView: creditCardView)
           // hostingController.modalPresentationStyle = .fullScreen
            presenter.present(hostingController, animated: true, completion: nil)
            
        } catch {
            print("❌ Failed to create payment request: \(error.localizedDescription)")
            completion(.failed(error as! MoyasarError))
        }
    }
}
