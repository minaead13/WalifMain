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
        totalLabel.text = "\(order.total ?? 0)"
        createdAtLabel.text = "\("Order Time :".localized) \(order.createdAt?.formatOrderDateString() ?? "")"
        merchantImageVIew.setImage(from: order.merchantImage)
        setStatusViews(statusValue: order.statusValue ?? 0)
    }
    
    func setStatusViews(statusValue: Int) {
        switch statusValue {
        case 1:
            outerView.borderColor = UIColor(hex: "A5C013")
            statusView.backgroundColor = UIColor(red: 165/255, green: 192/255, blue: 19/255, alpha: 0.1)
        case 0:
            outerView.borderColor = UIColor(hex: "3086A3")
            statusView.backgroundColor = UIColor(red: 48/255, green: 134/255, blue: 163/255, alpha: 0.1)
        case 2:
            outerView.borderColor = UIColor(hex: "5A3AEA")
            statusView.backgroundColor = UIColor(red: 90/255, green: 58/255, blue: 234/255, alpha: 0.1)
        case 3:
            outerView.borderColor = UIColor(hex: "005E44")
            statusView.backgroundColor = UIColor(red: 0/255, green: 94/255, blue: 68/255, alpha: 0.1)
        case 4:
            outerView.borderColor = UIColor(hex: "FF090D")
            statusView.backgroundColor = UIColor(red: 255/255, green: 9/255, blue: 13/255, alpha: 0.1)
        default:
            break
        }
    }
}
