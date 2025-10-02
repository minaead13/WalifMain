//
//  PaymentSelectionViewController.swift
//  Wlif
//
//  Created by Mina Eid on 23/09/2025.
//

import UIKit

class PaymentSelectionViewController: UIViewController {
    
    @IBOutlet weak var onlinePaymentImageView: UIImageView!
    @IBOutlet weak var walletTotalLabel: UILabel!
    @IBOutlet weak var walletSelectImageView: UIImageView!
    
    private var selectedMethod: PaymentMethod = .online
    var completionHandler: ((PaymentMethod) -> Void)?
    let viewModel = WalletViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        updateSelectionUI()
        bind()
        viewModel.getWallet()
    }
    
    func bind() {
        viewModel.onWalletFetched = { [weak self] wallet in
            self?.walletTotalLabel.text = "\(wallet?.balance ?? "")"
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self,
                  let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self.showLoadingIndicator()
                } else {
                    self.hideLoadingIndicator()
                }
            }
        }
    }
    
    @IBAction func didTapOnlinePaymentBtn(_ sender: Any) {
        selectedMethod = .online
        updateSelectionUI()
    }
    
    @IBAction func didTapWalletBtn(_ sender: Any) {
        selectedMethod = .wallet
        updateSelectionUI()
    }
    
    
    @IBAction func didTapConfirmBtn(_ sender: Any) {
        completionHandler?(selectedMethod)
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapDismissBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func updateSelectionUI() {
        onlinePaymentImageView.image = UIImage(
            named: selectedMethod == .online ? "selected.yellow" : "unselected"
        )
        
        walletSelectImageView.image = UIImage(
            named: selectedMethod == .wallet ? "selected.yellow" : "unselected"
        )
    }
}

enum PaymentMethod {
    case online
    case wallet
}
