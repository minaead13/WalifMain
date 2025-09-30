//
//  ServiceDetailsViewController.swift
//  Wlif
//
//  Created by OSX on 21/07/2025.
//

import UIKit

class ServiceDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = ServiceDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        bind()
        viewModel.getServiceDetails()
        tableView.registerCell(cell: ServiceDetailsTableViewCell.self)
        setupHeaderActions()
    }
    

    func bind() {
        viewModel.onServiceDetailsFetched = { [weak self] services in
            guard let self else { return }
            titleLabel.text = viewModel.title
            serviceNameLabel.text = viewModel.serviceDetails?.service?.name ?? ""
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
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ServiceDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.serviceDetails?.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailsTableViewCell", for: indexPath) as? ServiceDetailsTableViewCell else { return UITableViewCell() }
        
        if let data = viewModel.serviceDetails?.categories?[indexPath.row] {
            cell.configure(data: data)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VetAppointmentBookingVC") as! VetAppointmentBookingVC
        vc.viewModel.category = viewModel.serviceDetails?.categories?[indexPath.row]

        vc.viewModel.title = viewModel.title ?? ""
        vc.viewModel.serviceType = viewModel.serviceDetails?.service?.name ?? ""
        vc.viewModel.store = viewModel.store
        vc.viewModel.storeID = viewModel.store?.id
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

