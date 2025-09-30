//
//  OrderHistoryTableViewCell.swift
//  Wlif
//
//  Created by OSX on 02/09/2025.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var merchantImageVIew: UIImageView!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(order: OrderData) {
        orderNumberLabel.text = "\("Order Number :".localized) #\(order.orderNumber ?? "")"
        statusLabel.text = "● \(order.status ?? "")"
        merchantNameLabel.text = "\(order.merchantName ?? "") +\(order.itemsCount ?? 0)"
        totalLabel.text = order.total
        createdAtLabel.text = "\("Order Time :".localized) \(order.createdAt?.formatOrderDateString() ?? "")"
        merchantImageVIew.setImage(from: order.merchantImage)
    }
}
