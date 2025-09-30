//
//  PetsStoresViewController.swift
//  Wlif
//
//  Created by OSX on 07/07/2025.
//

import UIKit

class PetsStoresViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = PetsStoresViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind()
        viewModel.getPetsStores()
        setupHeaderActions()
    }
    
    func setupTableView() {
        tableView.registerCell(cell: PetsStoresTableViewCell.self)
        tableView.registerCell(cell: BannerTableViewCell.self)
    }
    
    func bind() {
        viewModel.onPetsStoresFetched = { [weak self] services in
            guard let self else { return }
            if viewModel.serviceType == .petStores {
                titleLabel.text = "All Stores".localized
            } else if viewModel.serviceType == .veterinaryServices {
                titleLabel.text = "VeterinaryServices".localized
            }
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


extension PetsStoresViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return viewModel.petsStores?.data?.count ?? 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as? BannerTableViewCell else { return UITableViewCell() }
            
            cell.banners = viewModel.petsStores?.banners ?? []
            
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetsStoresTableViewCell", for: indexPath) as? PetsStoresTableViewCell else { return UITableViewCell() }
            
            if let data = viewModel.petsStores?.data {
                cell.config(data: data[indexPath.row])
            }
            
            cell.selectionStyle = .none
            return cell
        
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 165
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 1 {
            if viewModel.serviceType == .petStores {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoreViewController") as! StoreViewController
                vc.viewModel.id = viewModel.petsStores?.data?[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)
            } else if viewModel.serviceType == .veterinaryServices {
                let storyboard = UIStoryboard(name: "VeterinaryServices", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "VetsServicesViewController") as! VetsServicesViewController
                vc.viewModel.id = viewModel.petsStores?.data?[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
