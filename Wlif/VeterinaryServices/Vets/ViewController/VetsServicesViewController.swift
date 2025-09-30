//
//  VetsServicesViewController.swift
//  Wlif
//
//  Created by OSX on 20/07/2025.
//

import UIKit

class VetsServicesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = VetsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        bind()
        viewModel.getVetsServices()
        tableView.registerCell(cell: StoreDetailsTableViewCell.self)
        servicesCollectionView.registerCell(cell: VetsServicesCollectionViewCell.self)
        setupHeaderActions()
    }
    

    func bind() {
        viewModel.onVetsServicesFetched = { [weak self] services in
            guard let self else { return }
            titleLabel.text = viewModel.vetsServices?.store?.name
            servicesCollectionView.reloadData()
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

extension VetsServicesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailsTableViewCell", for: indexPath) as? StoreDetailsTableViewCell else { return UITableViewCell() }
        
        if let data = viewModel.vetsServices?.store {
            cell.config(data: data)
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension VetsServicesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.vetsServices?.services?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VetsServicesCollectionViewCell", for: indexPath) as? VetsServicesCollectionViewCell else { return UICollectionViewCell() }
        cell.vetsLabel.text = viewModel.vetsServices?.services?[indexPath.row].name ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 16
        let numberOfItemsPerRow: CGFloat = 2

        let width = (collectionView.frame.width - totalSpacing) / numberOfItemsPerRow

        return CGSize(width: width, height: 133)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceDetailsViewController") as! ServiceDetailsViewController
        
        vc.viewModel.id = viewModel.vetsServices?.services?[indexPath.row].id ?? 0
        vc.viewModel.title = viewModel.vetsServices?.store?.name
        vc.viewModel.store = viewModel.vetsServices?.store
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
