//
//  ProductDetailsViewController.swift
//  Wlif
//
//  Created by OSX on 09/07/2025.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ProductDetailsViewModel()
    let cartViewModel = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind()
        viewModel.getProductDetails()
    }
    
    
    func bind() {
        viewModel.onproductDetailsFetched = { [weak self] services in
            self?.tableView.reloadData()
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
    
    func setupTableView() {
        tableView.registerCell(cell: ProductDetailsTableViewCell.self)
    }
   
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ProductDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsTableViewCell", for: indexPath) as? ProductDetailsTableViewCell else { return UITableViewCell() }
        
        cell.productDetails = viewModel.productDetails
        cell.updateQnty = { [weak self] action, qty in
            guard let self else { return }
            
            let productId = viewModel.productDetails?.product?.id
            
            switch action {
            case .increase:
                cartViewModel.addCartProduct(productId: productId ?? 0, qty: 1)
            case .decrease:
                print("minus")
            case .delete:
                print("delete")
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
}
