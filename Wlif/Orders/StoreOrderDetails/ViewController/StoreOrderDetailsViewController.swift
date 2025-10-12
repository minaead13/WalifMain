//
//  StoreOrderDetailsViewController.swift
//  Wlif
//
//  Created by OSX on 03/09/2025.
//

import UIKit

class StoreOrderDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var ratingBtn: UIButton!
    
    let viewModel = StoreOrderDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setTableView()
        bind()
        viewModel.getOrderDetails()
        setupHeaderActions()
    }
    
    func setTableView() {
        tableView.registerCell(cell: LocationOrderTableViewCell.self)
        tableView.registerCell(cell: ItemsOrderTableViewCell.self)
        tableView.registerCell(cell: PaymentInfoDetailsTableViewCell.self)
    }
    
    func bind() {
        viewModel.onOrderDetailsFetched = { [weak self] orderDetails in
            let shouldShowRatingButton = (orderDetails?.statusValue == 3 && orderDetails?.isRated == false)
            self?.ratingBtn.isHidden = !shouldShowRatingButton
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
    
    @IBAction func didTapRatingBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderRatingViewController") as! OrderRatingViewController
        vc.viewModel.orderID = viewModel.orderDetails?.id
        vc.viewModel.isFromStore = true
        vc.viewModel.completionHandler = { [weak self] in
            self?.viewModel.getOrderDetails()
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
}

extension StoreOrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationOrderTableViewCell", for: indexPath) as? LocationOrderTableViewCell else { return UITableViewCell() }
            if let info = viewModel.orderDetails {
                cell.locationLabel.text = info.addressName
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsOrderTableViewCell", for: indexPath) as? ItemsOrderTableViewCell else { return UITableViewCell() }
            if let data = viewModel.orderDetails {
                cell.order = data
            }
            cell.selectionStyle = .none
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentInfoDetailsTableViewCell", for: indexPath) as? PaymentInfoDetailsTableViewCell else { return UITableViewCell() }
            if let payment = viewModel.orderDetails {
                cell.configure(payment: payment)
            }
            cell.selectionStyle = .none
            return cell
            
        default :
            return UITableViewCell()
        }
    }
}
