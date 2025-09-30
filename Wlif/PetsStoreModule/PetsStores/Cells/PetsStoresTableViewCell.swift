//
//  ServiceDetailsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 07/07/2025.
//

import UIKit

class PetsStoresTableViewCell: UITableViewCell {
    
    @IBOutlet weak var petsStoreImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(data: PetsStoresModel) {
        petsStoreImageView.setImage(from: data.image)
        self.nameLabel.text = data.name
        self.descLabel.text = data.shortDesc
        self.deliveryLabel.text = data.delivery
        self.distanceLabel.text = data.distance
    }
    
    func config(data: AdoptionData) {
        petsStoreImageView.setImage(from: data.image)
        self.nameLabel.text = data.petName
        self.descLabel.text = data.description
        self.deliveryLabel.isHidden = true
        self.distanceLabel.text = data.distance
        distanceView.backgroundColor = UIColor(red: 190/255, green: 226/255, blue: 242/255, alpha: 0.32)
    }
    
    func configure(data: FavModel) {
        petsStoreImageView.setImage(from: data.image)
        nameLabel.text = data.petName
        descLabel.text = data.description
    }
    
}
