//
//  OfferStoresDetailsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 17/08/2025.
//

import UIKit

class OfferStoresDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var disctanceLabel: UILabel!
    @IBOutlet weak var closesAtLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func configure(store: StoreOffer) {
        animalImageView.setImage(from: store.image)
        nameLabel.text = store.name
        descriptionLabel.text = store.shortDesc
        deliveryLabel.text = store.delivery
        rateLabel.text = "(\(store.rate ?? 0))"
        disctanceLabel.text = store.distance
        closesAtLabel.text = store.closesAt
    }
    
    func configure(vets: Clinic) {
        animalImageView.setImage(from: vets.image)
        nameLabel.text = vets.name
        descriptionLabel.text = vets.shortDesc
        deliveryLabel.text = vets.delivery
        rateLabel.text = "(\(vets.rate ?? 0))"
        disctanceLabel.text = vets.distance
        closesAtLabel.text = vets.closesAt
    }
}
