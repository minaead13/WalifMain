//
//  HotelBookingVC.swift
//  Wlif
//
//  Created by OSX on 29/07/2025.
//

import UIKit

class HotelBookingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = HotelBookingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        titleLabel.text = "\("Booking".localized) \(">".localized) \(viewModel.store?.name ?? "")"
        tableView.reloadData()
        setupHeaderActions()
    }
    
    func setupTableView() {
        tableView.registerCell(cell: HotelBookingServicesTableViewCell.self)
        tableView.registerCell(cell: HotelBookingTableViewCell.self)
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
    
    
    @IBAction func didTabBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapContinueBtn(_ sender: Any) {
        guard
            let fromDate = viewModel.fromDate, !fromDate.isEmpty,
            let toDate = viewModel.toDate, !toDate.isEmpty,
            let noOfAnimals = viewModel.noOfAnimals, !noOfAnimals.isEmpty,
            let room = viewModel.room,
            let selectedServices = viewModel.selectedServices, !selectedServices.isEmpty
        else { return }
        
        let bookingInfo = HotelBookingInfo(
            hotelId: viewModel.id,
            fromDate: fromDate,
            toDate: toDate,
            noOfAnimals: noOfAnimals,
            room: room,
            services: selectedServices,
            store: viewModel.store
        )
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "HotelConfirmBookingVC") as! HotelConfirmBookingVC
        vc.viewModel.bookingInfo = bookingInfo
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HotelBookingVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingTableViewCell", for: indexPath) as? HotelBookingTableViewCell else { return UITableViewCell() }
                        
            cell.handleSelectionDate = { [weak self] in
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "HotelBookingSelectionDateVC") as! HotelBookingSelectionDateVC
                vc.completionHandler = { [weak self] from, to in
                    cell.dateLabel.text = "\(from) - \(to)"
                    self?.viewModel.fromDate = from
                    self?.viewModel.toDate = to
                }
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true)
            }
            
            cell.handleSelectionRoom = { [weak self] in
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "HotelRoomsVC") as! HotelRoomsVC
                
                vc.viewModel.completionHandler = { [weak self] room in
                    self?.viewModel.room = room
                    self?.tableView.reloadData()
                }
                vc.viewModel.id = self?.viewModel.id
                self?.present(vc, animated: true)
            }
            
            cell.onAnimalsTextChanged = { [weak self] enteredText in
                self?.viewModel.noOfAnimals = enteredText
            }
            
            if let room = viewModel.room {
                cell.roomView.isHidden = false
                cell.selectStack.isHidden = true
                cell.roomContainerViewHeightConstant.constant = 136
                cell.roomNameLabel.text = room.name
                cell.roomPriceLabel.text = "\(room.price ?? 0) SR - Of Day"
                cell.services = room.services ?? []
            } else {
                cell.roomView.isHidden = true
                cell.selectStack.isHidden = false
                cell.roomContainerViewHeightConstant.constant = 50
            }
            
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingServicesTableViewCell", for: indexPath) as? HotelBookingServicesTableViewCell else { return UITableViewCell() }
            
            cell.services = viewModel.services ?? []
            
            cell.didUpdateSelection = { [weak self] selectedServices in
                self?.viewModel.selectedServices = selectedServices
            }
            
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
