//
//  StoreViewController.swift
//  Wlif
//
//  Created by OSX on 07/07/2025.
//

import UIKit

class StoreViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = StoreViewModel()
    let cartViewModel = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        setupCollectionView()
        bind()
        viewModel.getStoreData()
        setupHeaderActions()
    }
    

    func bind() {
        viewModel.onStoreFetched = { [weak self] services in
            self?.tableView.reloadData()
            self?.collectionView.reloadData()
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
        tableView.registerCell(cell: StoreDetailsTableViewCell.self)
        tableView.registerCell(cell: ProductTableViewCell.self)
    }
    
    func setupCollectionView() {
        collectionView.registerCell(cell: CategoryCollectionViewCell.self)
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

extension StoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return viewModel.store?.products?.count ?? 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailsTableViewCell", for: indexPath) as? StoreDetailsTableViewCell else { return UITableViewCell() }
            
            if let data = viewModel.store?.store {
                cell.config(data: data)
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
           
            if let data = viewModel.store?.products?[indexPath.row] {
                cell.config(data: data)
            }
            cell.updateQnty = { [weak self] action, qty in
                guard let self else { return }
                
                let productId = viewModel.store?.products?[indexPath.row].id ?? 0
                
                switch action {
                case .increase:
                    cartViewModel.addCartProduct(productId: productId, qty: qty)
                case .decrease:
                    print("minus")
                case .delete:
                    print("delete")
                }
            }
            
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.viewModel.productId = viewModel.store?.products?[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension StoreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.store?.categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell() }
        
        let isSelected = indexPath.row == viewModel.selectedIndex
        cell.outerView.backgroundColor = isSelected ? .label : .clear
        cell.outerView.borderColor = isSelected ? .clear : UIColor(hex: "A1A1A1")
        cell.outerView.borderWidth = isSelected ? 0 : 1
        cell.nameLabel.textColor = isSelected ? .white : UIColor(hex: "A1A1A1")
        cell.nameLabel.text = viewModel.store?.categories?[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedIndex = indexPath.row
        collectionView.reloadData()
        viewModel.getStoreData(categroyID: viewModel.store?.categories?[indexPath.row].id)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont(name: "IBMPlexSansArabic-SemiBold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        let title = viewModel.store?.categories?[indexPath.row].name ?? ""
        let textWidth = ceil(title.widthOfString(usingFont: font))
        let horizontalPadding = 32
        let cellWidth = textWidth + CGFloat(horizontalPadding)
        return CGSize(width: cellWidth, height: 43)
    }
}
