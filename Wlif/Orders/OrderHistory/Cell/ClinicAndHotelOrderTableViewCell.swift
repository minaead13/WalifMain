//
//  ClinicAndHotelOrderTableViewCell.swift
//  Wlif
//
//  Created by OSX on 02/09/2025.
//

import UIKit

class ClinicAndHotelOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var merchantImageVIew: UIImageView!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var entryOrServiceLabel: UILabel!
    @IBOutlet weak var exitDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(order: ClinicAndHotelOrderHistory, index: Int) {
        orderNumberLabel.text = "\("Order Number :".localized) #\(order.orderNumber ?? "")"
        statusLabel.text = "● \(order.status ?? "")"
        merchantNameLabel.text = "\(order.merchantName ?? "")"
        totalLabel.text = order.total
        createdAtLabel.text = "\(order.createdAt?.formatOrderDateString() ?? "")"
        merchantImageVIew.setImage(from: order.merchantImage)
        
        if index == 1 {
            entryOrServiceLabel.text = "\("Service Type :".localized) \(order.serviceType ?? "")"
            exitDateLabel.isHidden = true
        } else {
            entryOrServiceLabel.text = "\("Entry Date :") \(order.entryDate ?? "")"
            exitDateLabel.text = "\("Exit Date :") \(order.exitDate ?? "")"
            exitDateLabel.isHidden = false
        }
    }
    
}
