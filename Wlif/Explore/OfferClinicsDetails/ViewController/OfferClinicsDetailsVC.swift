//
//  OfferClinicsDetailsVC.swift
//  Wlif
//
//  Created by OSX on 18/08/2025.
//

import UIKit

class OfferClinicsDetailsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = OfferClinicsDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setTableView()
        bind()
        viewModel.fetchOffers()
        setupHeaderActions()
    }
    
    func setTableView() {
        tableView.registerCell(cell: OfferClinicServicesTableViewCell.self)
        tableView.registerCell(cell: OfferStoresDetailsTableViewCell.self)
      }

    func bind() {
        viewModel.onVetsOffersFetched = { [weak self] in
            guard let self else { return }
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
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension OfferClinicsDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OfferStoresDetailsTableViewCell", for: indexPath) as? OfferStoresDetailsTableViewCell else { return UITableViewCell()}
            if viewModel.fromViewAll {
                if let data = viewModel.storeOffersDetails {
                    cell.configure(store: data)
                }
            } else {
                if let data = viewModel.clinic {
                    cell.configure(vets: data)
                }
            }
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OfferClinicServicesTableViewCell", for: indexPath) as? OfferClinicServicesTableViewCell else { return UITableViewCell()}
            if let data = viewModel.vetsOffers {
                cell.offers = data
            }
            
            cell.didSelect = { [weak self] offer in
                guard let self = self else { return }
                
                let sourceName = viewModel.fromViewAll ? (viewModel.storeOffersDetails?.name ?? "") : (viewModel.clinic?.name ?? "")
                let sourceImage = viewModel.fromViewAll ? (viewModel.storeOffersDetails?.image ?? "") : (viewModel.clinic?.image ?? "")
                let sourceDistance = viewModel.fromViewAll ? (viewModel.storeOffersDetails?.distance ?? "") : (viewModel.clinic?.distance ?? "")
                
                let storyboard = UIStoryboard(name: "VeterinaryServices", bundle: nil)
                guard let vc = storyboard.instantiateViewController(withIdentifier: "VetAppointmentBookingVC") as? VetAppointmentBookingVC else { return }
                
                vc.viewModel.category = Category(
                    id: offer.id,
                    name: offer.name,
                    desc: offer.desc,
                    rate: offer.rate,
                    price: offer.price
                )
                
                vc.viewModel.title = sourceName
                vc.viewModel.serviceType = offer.name ?? ""
                vc.viewModel.store = Store(image: sourceImage, name: sourceName, distance: sourceDistance)
                vc.viewModel.storeID = offer.id
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
        }
    }
}
