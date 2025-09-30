//
//  ReviewsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 29/07/2025.
//

import UIKit
import Cosmos

class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(data: HotelReview) {
        reviewImageView.setImage(from: data.image)
        nameLabel.text = data.name
        rateView.rating = Double(data.rate ?? 0)
        descLabel.text = data.comment
        dateLabel.text = data.date
    }
    
}
