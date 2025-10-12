//
//  VetsConfirmBookingVC.swift
//  Wlif
//
//  Created by OSX on 23/07/2025.
//

import UIKit
import PassKit
import MoyasarSdk
import SwiftUI

class VetsConfirmBookingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = VetsConfirmBookingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind()
        setupHeaderActions()
    }
    
    func setupTableView() {
        tableView.registerCell(cell: nameDetailsTableViewCell.self)
        tableView.registerCell(cell: ServiceDataTableViewCell.self)
        tableView.registerCell(cell: PaymentMethodTableViewCell.self)
        tableView.registerCell(cell: PaymentInfoTableViewCell.self)
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
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTapContinueBtn(_ sender: Any) {
        
        self.viewModel.addVetOrder { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                if viewModel.selectedMethod == .online {
                    guard let amount = viewModel.category?.price else { return }
                    
                    PaymentCoordinator.shared.startPayment(
                        from: self,
                        amount: amount,
                        description: "Veterinary booking for \(viewModel.store?.name ?? "")",
                        metadata: [
                            "order_id": .stringValue(UUID().uuidString),
                            "user_id": .integerValue(12345)
                        ]
                    ) { [weak self] result in
                        self?.handlePaymentResult(result)
                    }
                } else {
                    goToConfirmVC()
                }
                case .failure(let error):
                    print("❌ Failed to add order: \(error.localizedDescription)")
                }
        }
        
    }
    
    // MARK: - Handle Payment Flow
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
                    let vc = storyboard.instantiateViewController(withIdentifier: "ClinicAndHotelOrderDetailsVC") as! ClinicAndHotelOrderDetailsVC
                    vc.viewModel.id = data.orderId
                    vc.viewModel.slogan = .veterinaryServices
                    vc.viewModel.isFromSuccessScreen = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
               
            case .failure(let error):
                print("❌ Failed to add order: \(error.localizedDescription)")
            }
        }
    }
    
    func goToConfirmVC() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmOrderVC") as? ConfirmOrderVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension VetsConfirmBookingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "nameDetailsTableViewCell", for: indexPath) as? nameDetailsTableViewCell else { return UITableViewCell()}
            
            cell.vetImageView.setImage(from: viewModel.store?.image)
            cell.nameLabel.text = viewModel.store?.name
            cell.locationLabel.text = viewModel.store?.distance
            cell.selectionStyle = .none
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDataTableViewCell", for: indexPath) as? ServiceDataTableViewCell else { return UITableViewCell()}
            cell.serviceTypeLabel.text = viewModel.serviceType
            cell.dateLabel.text = viewModel.date
            cell.timeLabel.text = viewModel.selectedTime?.time
            cell.animalTypes = viewModel.selectedAnimalTypes
            cell.selectionStyle = .none
            return cell
            
        case 2:
            
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
            
        case 3:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentInfoTableViewCell", for: indexPath) as? PaymentInfoTableViewCell else { return UITableViewCell()}
            cell.totalLabel.text = "\(viewModel.category?.price ?? 0)"
            cell.subTotalLabel.text = "\(viewModel.category?.price ?? 0)"
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

extension VetsConfirmBookingVC: PKPaymentAuthorizationControllerDelegate {
    
    func startApplePayPayment() {
        let paymentRequest = PKPaymentRequest()
        
        paymentRequest.merchantIdentifier = "merchant.your.merchant.id"
        paymentRequest.countryCode = "SA"
        paymentRequest.currencyCode = "SAR"
        paymentRequest.supportedNetworks = [.visa, .masterCard, .mada]
        paymentRequest.merchantCapabilities = [.capability3DS, .capabilityCredit, .capabilityDebit]
        
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Booking Payment", amount: NSDecimalNumber(string: "\(viewModel.category?.price ?? 0)"))
        ]
        
        let controller = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        controller.delegate = self
        controller.present(completion: nil)
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                        didAuthorizePayment payment: PKPayment,
                                        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
//        MoyasarSDK.createApplePayPayment(token: payment.token, amount: viewModel.category?.price ?? 0, currency: "SAR", description: "Booking Payment") { result in
//            
//            switch result {
//            case .success(let paymentResult):
//                if paymentResult.status == "paid" {
//                    completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//                    self.handlePaymentSuccess(paymentResult)
//                } else {
//                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
//                }
//            case .failure(let error):
//                print("Payment failed: \(error.localizedDescription)")
//                completion(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
//            }
        // }
    }

    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss()
    }
    
}
