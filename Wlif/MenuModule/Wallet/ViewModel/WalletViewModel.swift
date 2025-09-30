//
//  WalletViewModel.swift
//  Wlif
//
//  Created by OSX on 27/08/2025.
//

import Foundation

class WalletViewModel {
    var isLoading: Observable<Bool> = Observable(false)
    
    var wallet: Wallet? {
        didSet {
            self.onWalletFetched?(wallet)
        }
    }
    
    var onWalletFetched: ((Wallet?) -> Void)?
    var balanceAdded: (() -> Void)?
    
    func getWallet() {
        self.isLoading.value = true
        NetworkManager.instance.request(Urls.wallet, parameters: nil, method: .get, type: Wallet.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                self?.wallet = data
            }
        }
    }
    
    func addBalance(amount: String, completion: @escaping () -> Void) {
        let params = ["amount": amount]
        self.isLoading.value = true
        NetworkManager.instance.request(Urls.addBalance, parameters: params, method: .post, type: Wallet.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                completion()
            }
        }
    }
}
