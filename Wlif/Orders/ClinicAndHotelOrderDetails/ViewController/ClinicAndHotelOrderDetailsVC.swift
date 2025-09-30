//
//  ClinicAndHotelOrderDetailsVC.swift
//  Wlif
//
//  Created by OSX on 02/09/2025.
//

import UIKit

class ClinicAndHotelOrderDetailsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = ClinicAndHotelOrderDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setTableView()
        bind()
        viewModel.getOrderDetails()
        setupHeaderActions()
    }
    
    func setTableView() {
        tableView.registerCell(cell: InfoTableViewCell.self)
        tableView.registerCell(cell: OrderInfoTableViewCell.self)
        tableView.registerCell(cell: PaymentInfoDetailsTableViewCell.self)
    }
    
    func bind() {
        viewModel.onOrderDetailsFetched = { [weak self] services in
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
}

extension ClinicAndHotelOrderDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as? InfoTableViewCell else { return UITableViewCell() }
            if let info = viewModel.orderDetails {
                cell.configure(info: info, slogan: viewModel.slogan ?? .unknown)
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderInfoTableViewCell", for: indexPath) as? OrderInfoTableViewCell else { return UITableViewCell() }
            if let data = viewModel.orderDetails {
                cell.configure(data: data)
                cell.animalTypes = viewModel.slogan == .veterinaryServices ? viewModel.orderDetails?.animalTypes ?? [] : viewModel.orderDetails?.services ?? []
            }
            cell.slogan = viewModel.slogan ?? .unknown
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentInfoDetailsTableViewCell", for: indexPath) as? PaymentInfoDetailsTableViewCell else { return UITableViewCell() }
            if let payment = viewModel.orderDetails {
                cell.configure(payment: payment, slogan: viewModel.slogan ?? .unknown)
            }
            return cell
            
        default :
            return UITableViewCell()
        }
    }
}
