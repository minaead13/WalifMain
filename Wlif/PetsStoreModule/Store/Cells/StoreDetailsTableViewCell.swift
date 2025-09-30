//
//  StoreDetailsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 07/07/2025.
//

import UIKit
import Cosmos

class StoreDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var closesAtLabel: UILabel!
    @IBOutlet weak var minmumLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func config(data: Store) {
        if let urlString = data.image,
           let url = URL(string: urlString) {
            petImageView.kf.setImage(with: url)
        }
        nameLabel.text = data.name
        reviewsLabel.text = "\(data.rate ?? 0)"
        deliveryLabel.text = data.delivery
        distanceLabel.text = data.distance ?? ""
        closesAtLabel.text = data.closesAt ?? ""
        minmumLabel.text = data.minuim ?? ""
        ratingView.rating = Double(data.rate ?? 0)
    }
    
}
