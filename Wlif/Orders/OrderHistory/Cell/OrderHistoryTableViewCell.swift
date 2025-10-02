//
//  OrderHistoryTableViewCell.swift
//  Wlif
//
//  Created by OSX on 02/09/2025.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var statusView: UIView!
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
        statusLabel.text = "\(order.status ?? "")"
        merchantNameLabel.text = "\(order.merchantName ?? "") +\(order.itemsCount ?? 0)"
        totalLabel.text = order.total
        createdAtLabel.text = "\("Order Time :".localized) \(order.createdAt?.formatOrderDateString() ?? "")"
        merchantImageVIew.setImage(from: order.merchantImage)
        setStatusViews(status: order.status ?? "")
    }
    
    func setStatusViews(status: String) {
        switch status {
        case "Preparing":
            outerView.borderColor = UIColor(hex: "A5C013")
            statusView.backgroundColor = UIColor(red: 165, green: 192, blue: 19, alpha: 0.1)
        case "Order Received":
            outerView.borderColor = UIColor(hex: "3086A3")
            statusView.backgroundColor = UIColor(red: 48, green: 134, blue: 163, alpha: 0.1)
        case "Out for Delivery":
            outerView.borderColor = UIColor(hex: "5A3AEA")
            statusView.backgroundColor = UIColor(red: 90, green: 58, blue: 234, alpha: 0.1)
        case "Delivery":
            outerView.borderColor = UIColor(hex: "005E44")
            statusView.backgroundColor = UIColor(red: 0, green: 94, blue: 68, alpha: 0.1)
        case "Reject":
            outerView.borderColor = UIColor(hex: "FF090D")
            statusView.backgroundColor = UIColor(red: 255, green: 9, blue: 13, alpha: 0.1)
        default:
            break
        }
    }
}
