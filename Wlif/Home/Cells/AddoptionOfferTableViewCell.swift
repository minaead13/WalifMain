//
//  AddoptionOfferTableViewCell.swift
//  Wlif
//
//  Created by OSX on 24/08/2025.
//

import UIKit

class AddoptionOfferTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var photosCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(adoptionOffers: AdoptionOffer) {
        nameLabel.text = adoptionOffers.petName
        animalImageView.setImage(from: adoptionOffers.image)
        descLabel.text = adoptionOffers.description
        photosCountLabel.text = "\(adoptionOffers.imagesCount) \("Photos".localized)"
    }
    
}
