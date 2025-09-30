//
//  PaymentInfoDetailsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 02/09/2025.
//

import UIKit

class PaymentInfoDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var deliveryValueOrTaxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var deliveryOrTaxTitleLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var taxStack: UIStackView!
    @IBOutlet weak var stackView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taxStack.isHidden = true
        stackView.isHidden = true
    }

    func configure(payment: OrderDetailsModel, slogan: Services) {
        let isVeterinary = slogan == .veterinaryServices
        
        paymentMethodLabel.text = payment.paymentGatway
        deliveryValueOrTaxLabel.text = isVeterinary ? payment.tax : payment.deliveryValue
        totalLabel.text = payment.total
        deliveryOrTaxTitleLabel.text = isVeterinary ? "Tax".localized : "Delivery value".localized
    }
    
    func configure(payment: StoreOrderModel) {
        paymentMethodLabel.text = payment.paymentGatway
        deliveryValueOrTaxLabel.text = payment.deliveryValue
        totalLabel.text = payment.total
        deliveryOrTaxTitleLabel.text = "Delivery value".localized
        taxStack.isHidden = false
        stackView.isHidden = false
        taxLabel.text = payment.tax
    }
}
