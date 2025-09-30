//
//  ServiceDetailsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 21/07/2025.
//

import UIKit
import Cosmos

class ServiceDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(data: Category) {
        nameLabel.text = data.name
        rateLabel.text = "(\(data.rate ?? 0))"
        rateView.rating = Double(data.rate ?? 0)
        descLabel.text = data.desc
        priceLabel.text = "\(data.price ?? 0)"
    }
    
    func configure(data: OfferVeterinaryServicesDetailsModel) {
        nameLabel.text = data.name
        rateLabel.text = "(\(data.rate ?? 0))"
        rateView.rating = Double(data.rate ?? 0)
        descLabel.text = data.desc
        priceLabel.text = "\(data.price ?? 0)"
    }
    
}
