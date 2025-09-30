//
//  OfferViewController.swift
//  Wlif
//
//  Created by OSX on 13/08/2025.
//

import UIKit

class OfferViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = OffersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setTableView()
        bind()
        viewModel.getOffers()
        setupHeaderActions()
    }
    
    func setTableView() {
        tableView.registerCell(cell: StoreOffersTableViewCell.self)
        tableView.registerCell(cell: ClinicsOffersTableViewCell.self)
        
    }
    
    func bind() {
        viewModel.onSectionsUpdated = { [weak self] in
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

    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OfferViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = viewModel.sections[indexPath.section]
        
        switch sectionData.type {
        case .store:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreOffersTableViewCell", for: indexPath) as? StoreOffersTableViewCell else { return UITableViewCell() }
            cell.stores = sectionData.items as? [StoreOffer] ?? []
            cell.handleSelection = { [weak self] in
                self?.navigateToAllOfferVC(serviceSolgan: "petStores", offersType: .store)
            }
            
            cell.didSelectItem = { [weak self] in
                guard let self else { return }
                let vc = storyboard?.instantiateViewController(identifier: "OfferStoresDetailsViewController") as! OfferStoresDetailsViewController
                vc.viewModel.storeOffersDetails = sectionData.items[indexPath.row] as? StoreOffer
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.selectionStyle = .none
            return cell
            
        case .clinic, .hotel:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClinicsOffersTableViewCell", for: indexPath) as? ClinicsOffersTableViewCell else { return UITableViewCell() }
            
            let type = sectionData.type
            let items = sectionData.items
            
            cell.clinics = items as? [Clinic] ?? []
                cell.selectionStyle = .none
                if type == .hotel {
                    cell.titleLabel.text = "Hotels".localized
                }
            
            cell.handleSelection = { [weak self] in
                self?.navigateToAllOfferVC(
                    serviceSolgan: type == .clinic ? "veterinaryServices" : "petHotel",
                    offersType: type
                )
            }
            
            cell.didSelectItem = { [weak self] in
                guard let self else { return }
                if sectionData.type == .clinic {
                    let vc = storyboard?.instantiateViewController(identifier: "OfferClinicsDetailsVC") as! OfferClinicsDetailsVC
                    vc.viewModel.clinic = sectionData.items[indexPath.row] as? Clinic
                    vc.viewModel.fromViewAll = false
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = storyboard?.instantiateViewController(identifier: "OfferHotelDetailsVC") as! OfferHotelDetailsVC
                    vc.viewModel.hotel = sectionData.items[indexPath.row] as? Clinic
                    vc.viewModel.fromViewAll = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.sections[indexPath.section].type {
        case .store:
            return 314
        case .clinic, .hotel:
            return 286
        }
    }
    
    func navigateToAllOfferVC(serviceSolgan: String, offersType: SectionType) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllOffersViewController") as! AllOffersViewController
        vc.viewModel.serviceSolgan = serviceSolgan
        vc.viewModel.offersType = offersType
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
