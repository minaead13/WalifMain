//
//  CartViewController.swift
//  Wlif
//
//  Created by OSX on 10/07/2025.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    let viewModel = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind()
        viewModel.getCart()
        getDeliveryFees()
    }
    
    func getDeliveryFees() {
        if LocationUtil.load() != nil {
            viewModel.getDeliveryFees()
        }
    }
    
    func bind() {
        viewModel.onCartFetched = { [weak self] cart in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.totalLabel.text = "\(cart?.total ?? 0)"
            }
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
    
    func setupTableView() {
        tableView.registerCell(cell: CartTableViewCell.self)
    }
    
    
    @IBAction func didTapContinueBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PetsStoreConfirmOrderVC") as! PetsStoreConfirmOrderVC
        vc.viewModel.cart = viewModel.cart
        vc.viewModel.deliveryFees = viewModel.deliveryFees
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cart?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        
        cell.item = viewModel.cart?.items?[indexPath.row]
        
        cell.updateQnty = { [weak self] action, qty in
            self?.handleQuantityAction(action, qty: qty, at: indexPath)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    private func handleQuantityAction(_ action: QtyAction, qty: Int, at indexPath: IndexPath) {
        guard let item = viewModel.cart?.items?[indexPath.row] else { return }
        
        let productId = item.productID
        let itemId = item.id
        
        switch action {
        case .increase:
            increaseQuantity(productId: productId ?? 0, qty: 1)
        case .decrease:
            decreaseQuantity(itemId: itemId ?? 0, productId: productId ?? 0, qty: 1)
        case .delete:
            deleteItem(itemId: itemId ?? 0)
        }
    }
    
    private func increaseQuantity(productId: Int, qty: Int) {
        viewModel.addCartProduct(productId: productId, qty: qty)
    }
    
    private func decreaseQuantity(itemId: Int, productId: Int, qty: Int) {
        viewModel.minusCartProduct(itemId: itemId, productId: productId, qty: qty)
    }
    
    private func deleteItem(itemId: Int) {
        viewModel.deleteItem(itemId: itemId)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
}
