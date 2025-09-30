//
//  PetsStoreConfirmOrderVC.swift
//  Wlif
//
//  Created by OSX on 03/08/2025.
//

import UIKit
import MoyasarSdk

class PetsStoreConfirmOrderVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = PetsStoreConfirmOrderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind()
        setupHeaderActions()
    }
    
    func setupTableView() {
        tableView.registerCell(cell: PetStoreLocationAndProductsCell.self)
        tableView.registerCell(cell: PaymentMethodTableViewCell.self)
        tableView.registerCell(cell: StorePaymentInfoTableViewCell.self)
        tableView.registerCell(cell: DeliveryFeesTableViewCell.self)
    }
    
    func bind() {
    
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
    
    @IBAction func didTapContinueBtn(_ sender: Any) {
        if LocationUtil.load() != nil {
            viewModel.addStoreOrder { [weak self] result in
                guard let self else { return }
                switch result {
                case .success:
                    if viewModel.selectedMethod == .online {
                        guard let total = viewModel.cart?.total  else { return }
                        let amountInHalalas = Int(total)
                        
                        PaymentCoordinator.shared.startPayment(
                            from: self,
                            amount: amountInHalalas,
                            metadata: [
                                "order_id": .stringValue(UUID().uuidString),
                                "user_id": .integerValue(12345)
                            ]
                        ) { [weak self] result in
                            self?.handlePaymentResult(result)
                        }
                    } else {
                        self.goToConfirmVC()
                    }
                case .failure(let error):
                    print("❌ Failed to add order: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func handlePaymentResult(_ result: PaymentResult) {
        switch result {
        case .completed(let payment):
            addOrder(payment: payment, status: payment.status == .paid ? "success" : "failed")
            
        case .failed(let error):
            addOrder(status: "failed")
            
        case .canceled:
            addOrder(status: "cancelled")
            
        @unknown default:
            print("⚠️ Unknown payment result.")
        }
    }
    
    private func addOrder(payment: ApiPayment? = nil, status: String) {
        viewModel.payment = payment
        self.dismiss(animated: true)
        
        self.viewModel.addpayment(status: status) { [weak self] result in
            switch result {
            case .success(let data):
                if payment?.status == .paid {
                    self?.goToConfirmVC()
                } else {
                    let storyboard = UIStoryboard(name: "Orders", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "StoreOrderDetailsViewController") as! StoreOrderDetailsViewController
                    vc.viewModel.id = data.orderId
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print("❌ Failed to add order: \(error.localizedDescription)")
            }
        }
    }
    
    func goToConfirmVC() {
        let stoyboard = UIStoryboard(name: "VeterinaryServices", bundle: nil)
        let vc = stoyboard.instantiateViewController(withIdentifier: "ConfirmOrderVC") as! ConfirmOrderVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PetsStoreConfirmOrderVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetStoreLocationAndProductsCell", for: indexPath) as? PetStoreLocationAndProductsCell else {
                return UITableViewCell()
            }
            
            cell.handleLocationSelection = { [weak self] in
                let storyboard = UIStoryboard(name: "Adoption", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
                
                vc.viewModel.completionHandler = { [weak self] in
                    guard let self else { return }
                    cell.locationLabel.text = LocationUtil.load()?.address
                    viewModel.getDeliveryFees()
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.items = viewModel.cart?.items ?? []
            
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath) as? PaymentMethodTableViewCell else { return UITableViewCell()}
            cell.completionHandler = { [weak self] in
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "PaymentSelectionViewController") as! PaymentSelectionViewController
                vc.completionHandler = { [weak self] PaymentMethod in
                    self?.viewModel.selectedMethod = PaymentMethod
                }
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true)
            }
            cell.selectionStyle = .none
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryFeesTableViewCell", for: indexPath) as? DeliveryFeesTableViewCell else { return UITableViewCell()}
            cell.costLabel.text = "\(viewModel.deliveryFees?.cost ?? 0)"
            cell.expectedDeliveryTime.text = viewModel.deliveryFees?.expectedDeliveryTime
            cell.selectionStyle = .none
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StorePaymentInfoTableViewCell", for: indexPath) as? StorePaymentInfoTableViewCell else { return UITableViewCell()}
            cell.subTotalLabel.text = "\(viewModel.cart?.subtotal ?? 0)"
           // cell.deliveryValueLabel.text = viewModel.cart?.deliveryValue
            cell.subTotalCountLabel.text = "\("Subtotal".localized) (\(viewModel.cart?.items?.count ?? 0) \("items".localized))"
            cell.taxLabel.text = viewModel.cart?.tax
            cell.totalLabel.text = "\(viewModel.cart?.total ?? 0)"
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
       
    }
    
}
