//
//  LogoutViewController.swift
//  Wlif
//
//  Created by OSX on 10/08/2025.
//

import UIKit

class LogoutViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    let viewModel = LogoutViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        bind()
        setTitleMessage()
    }
    
    func setTitleMessage() {
        if viewModel.isDeleteAddress {
            titleLabel.text = "The address will be deleted?".localized
        }
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
    

    @IBAction func logout(_ sender: Any) {
        if viewModel.isDeleteAddress {
            viewModel.completionHandler?()
            self.dismiss(animated: true)
            return
        }
        
        viewModel.logout { [weak self] result in
            switch result {
            case .success(_):
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "loginVC") as! UINavigationController
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
                
            case .failure(let error):
                print("error")
            }
        }
    }
    
    @IBAction func didTapDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
