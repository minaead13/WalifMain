//
//  OfferHotelDetailsVC.swift
//  Wlif
//
//  Created by OSX on 20/08/2025.
//

import UIKit

class OfferHotelDetailsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = OfferHotelDetailsViewModel()
    
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
        tableView.registerCell(cell: HotelRoomTableViewCell.self)
        tableView.registerCell(cell: OfferStoresDetailsTableViewCell.self)
      }

    func bind() {
        viewModel.onOffersFetched = { [weak self] in
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

extension OfferHotelDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.hotelsOffers?.count ?? 0
            
        default:
            return 0
        }
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
                if let data = viewModel.hotel {
                    cell.configure(vets: data)
                }
            }
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelRoomTableViewCell", for: indexPath) as? HotelRoomTableViewCell else { return UITableViewCell()}
            if let data = viewModel.hotelsOffers?[indexPath.row] {
                cell.configure(data: data)
                cell.services = data.services ?? []
            }

            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "PetHotel", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HotelBookingVC") as! HotelBookingVC
            let room = viewModel.hotelsOffers?[indexPath.row]
            vc.viewModel.services = viewModel.hotelsOffers?[indexPath.row].services
            vc.viewModel.id =  viewModel.hotelsOffers?[indexPath.row].id
            
            let sourceName = viewModel.fromViewAll ? (viewModel.storeOffersDetails?.name ?? "") : (viewModel.hotel?.name ?? "")
            let sourceImage = viewModel.fromViewAll ? (viewModel.storeOffersDetails?.image ?? "") : (viewModel.hotel?.image ?? "")
            let sourceDistance = viewModel.fromViewAll ? (viewModel.storeOffersDetails?.distance ?? "") : (viewModel.hotel?.distance ?? "")
            
            vc.viewModel.store = PetHotel(image: sourceImage, name: sourceName, distance: sourceDistance)
            vc.viewModel.room = RoomModel(id: room?.id, name: room?.name, animalsNumber: room?.animalsNumber, price: room?.price, services: room?.services)
            
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }
}
