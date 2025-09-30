//
//  TermsVC.swift
//  Wlif
//
//  Created by OSX on 06/08/2025.
//

import UIKit

class TermsVC: UIViewController {
    
    @IBOutlet weak var termTextView: UITextView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = TermsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        bind()
        viewModel.getTerms()
        setupHeaderActions()
    }
    
    func bind() {
        viewModel.onTermsFetched = { [weak self] terms in
            guard let self else { return }
            termTextView.text = terms?.terms?.htmlToString
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
    
    func setupHeaderActions() {
        headerView.onCartTap = { [weak self] in
            self?.navigate(to: CartViewController.self, from: "Home", storyboardID: "CartViewController")
        }
        
        headerView.onSideMenuTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        headerView.onHomeTap = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }

    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
