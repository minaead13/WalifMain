//
//  ChargeWalletViewController.swift
//  Wlif
//
//  Created by OSX on 27/08/2025.
//

import UIKit

class ChargeWalletViewController: UIViewController {
    
    
    @IBOutlet weak var amounTextField: UITextField!
    
    let viewModel = WalletViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        bind()
    }
    
    func bind() {
       
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
    
    
    @IBAction func didTapDismissBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapChargeBtn(_ sender: Any) {
        if let amount = amounTextField.text, !amount.isEmpty {
            viewModel.addBalance(amount: amount.replacedArabicDigitsWithEnglish) { [weak self] in
                self?.viewModel.balanceAdded?()
                self?.dismiss(animated: true)
            }
        }
    }
    
}
