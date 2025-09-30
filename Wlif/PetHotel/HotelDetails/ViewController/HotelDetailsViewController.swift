//
//  HotelDetailsViewController.swift
//  Wlif
//
//  Created by OSX on 28/07/2025.
//

import UIKit

class HotelDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = HotelDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind()
        viewModel.getPetHotelDetails()
        viewModel.getPetHotelReviews()
        setupHeaderActions()
    }
    
    func setupTableView() {
        tableView.registerCell(cell: HotelDetailsTableViewCell.self)
        tableView.registerCell(cell: HotelReviewsTableViewCell.self)
    }
    
    func bind() {
        viewModel.onPetHotelDetailsFetched = { [weak self] services in
            self?.tableView.reloadData()
        }
        
        viewModel.onPetHotelReviewsFetched = { [weak self] services in
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
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTapBookingBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HotelBookingVC") as! HotelBookingVC
        vc.viewModel.services = viewModel.petHotelDetails?.services
        vc.viewModel.store = viewModel.petHotelDetails?.store
        vc.viewModel.id = viewModel.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension HotelDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelDetailsTableViewCell", for: indexPath) as? HotelDetailsTableViewCell else { return UITableViewCell() }
            
            cell.hotelDetails = viewModel.petHotelDetails
            
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelReviewsTableViewCell", for: indexPath) as? HotelReviewsTableViewCell else { return UITableViewCell() }
            
            cell.reviews = viewModel.petHotelReviews ?? []
            
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
}
