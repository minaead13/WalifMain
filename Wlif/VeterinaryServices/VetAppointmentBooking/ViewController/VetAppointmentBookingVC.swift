//
//  VetAppointmentBookingVC.swift
//  Wlif
//
//  Created by OSX on 21/07/2025.
//

import UIKit

class VetAppointmentBookingVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = VetAppointmentBookingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        setupTableView()
        self.navigationController?.navigationBar.isHidden = true
        bind()
        titleLabel.text = viewModel.title
        priceLabel.text = "\(viewModel.category?.price ?? 0)"
        
//        continueView.layer.shadowColor = UIColor.black.cgColor
//        continueView.layer.shadowOpacity = 0.25
//        continueView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        continueView.layer.shadowRadius = 4
        
        viewModel.getCategoryDetails()
        setupHeaderActions()
    }
    

    func bind() {
        viewModel.onCategoryDetailsFetched = { [weak self] services in
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
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerCell(cell: ServiceDateAndTypeTableViewCell.self)
        tableView.registerCell(cell: SelectTimeTableViewCell.self)
        tableView.registerCell(cell: AnimalTypeTableViewCell.self)
    }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func didTapContinueBtn(_ sender: Any) {
        if viewModel.date?.isEmpty == false && !viewModel.selectedAnimalTypes.isEmpty && viewModel.selectedTime != nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VetsConfirmBookingVC") as! VetsConfirmBookingVC
            vc.viewModel.store = viewModel.store
            vc.viewModel.selectedAnimalTypes = viewModel.selectedAnimalTypes
            vc.viewModel.selectedTime = viewModel.selectedTime
            vc.viewModel.serviceType = viewModel.serviceType
            vc.viewModel.date = viewModel.date
            vc.viewModel.category = viewModel.category
            vc.viewModel.storeID = viewModel.storeID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension VetAppointmentBookingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDateAndTypeTableViewCell", for: indexPath) as? ServiceDateAndTypeTableViewCell else { return UITableViewCell() }
            
            cell.serviceType.text = viewModel.serviceType ?? ""
            
            cell.handleSelection = { [weak self] in
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "DateSelectionVC") as! DateSelectionVC
                vc.modalPresentationStyle = .overFullScreen
                vc.completionHandler = { [weak self] date in
                    cell.dateLabel.text = date
                    self?.viewModel.date = date
                }
                self?.present(vc, animated: true)
            }
            
            cell.selectionStyle = .none
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTimeTableViewCell", for: indexPath) as? SelectTimeTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.timeSlots = viewModel.categoryDetails?.timeSlots ?? []
            
            cell.handleSelection = { [weak self] selectedTime in
                self?.viewModel.selectedTime = selectedTime
            }
            
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalTypeTableViewCell", for: indexPath) as? AnimalTypeTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            
            cell.didUpdateSelection = { [weak self] selectedAnimalTypes in
                self?.viewModel.selectedAnimalTypes = selectedAnimalTypes
            }
            
            cell.animalTypes = viewModel.categoryDetails?.animalTypes ?? []
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}
