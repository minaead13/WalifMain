//
//  OfferStoresDetailsViewController.swift
//  Wlif
//
//  Created by OSX on 17/08/2025.
//

import UIKit

class OfferStoresDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = OfferStoresDetailsViewModel()
    let cartViewModel = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setTableView()
        bind()
        viewModel.fetchOffers()
        setupHeaderActions()
    }
    
    func setTableView() {
        tableView.registerCell(cell: OfferStoresProductsDetailsTableViewCell.self)
        tableView.registerCell(cell: OfferStoresDetailsTableViewCell.self)
      }

    func bind() {
        viewModel.onStoreOffersFetched = { [weak self] in
            guard let self else { return }
            tableView.reloadData()
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
        
        cartViewModel.isLoading.bind { [weak self] isLoading in
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
            self?.navigate(to: SettingsViewController.self, from: "Profile", storyboardID: "SettingsViewController")
        }
        
        headerView.onHomeTap = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OfferStoresDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OfferStoresDetailsTableViewCell", for: indexPath) as? OfferStoresDetailsTableViewCell else { return UITableViewCell()}
            if let data = viewModel.storeOffersDetails {
                cell.configure(store: data)
            }
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OfferStoresProductsDetailsTableViewCell", for: indexPath) as? OfferStoresProductsDetailsTableViewCell else { return UITableViewCell()}
            if let data = viewModel.storeOffers {
                cell.offers = data
            }
            
            cell.updateQnty = { [weak self] id in
                guard let self else { return }
                cartViewModel.addCartProduct(productId: id, qty: 1)
            }
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
