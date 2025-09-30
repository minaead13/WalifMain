//
//  AdoptionListViewController.swift
//  Wlif
//
//  Created by OSX on 13/07/2025.
//

import UIKit

class AdoptionListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = AdoptionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind()
        viewModel.getAdoptions()
        setupHeaderActions() 
    }
    
    func setupTableView() {
        tableView.registerCell(cell: PetsStoresTableViewCell.self)
        tableView.registerCell(cell: BannerTableViewCell.self)
    }
    
    func bind() {
        viewModel.onAdoptionListFetched = { [weak self] services in
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
            self?.navigate(to: SettingsViewController.self, from: "Profile", storyboardID: "SettingsViewController")
        }
        
        headerView.onHomeTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didTapMoreBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdoptionFilterViewController") as! AdoptionFilterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension AdoptionListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return viewModel.adoptionList?.data?.count ?? 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell", for: indexPath) as? BannerTableViewCell else { return UITableViewCell() }
            
            cell.banners = viewModel.adoptionList?.banners ?? []
            
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetsStoresTableViewCell", for: indexPath) as? PetsStoresTableViewCell else { return UITableViewCell() }
            
            if let data = viewModel.adoptionList?.data {
                cell.config(data: data[indexPath.row])
            }
            
            cell.selectionStyle = .none
            return cell
        
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            
        case 0:
           return 165
            
        case 1:
           return 105
        
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 1 {
            let selectedID = viewModel.adoptionList?.data?[indexPath.row].id
            
            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAdoptionViewController") as! AddAdoptionViewController
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdoptionDetailsViewController") as! AdoptionDetailsViewController
            vc.viewModel.id = selectedID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

