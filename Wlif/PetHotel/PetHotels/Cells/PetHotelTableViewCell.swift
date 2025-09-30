//
//  PetHotelTableViewCell.swift
//  Wlif
//
//  Created by OSX on 24/07/2025.
//

import UIKit

class PetHotelTableViewCell: UITableViewCell {

    @IBOutlet weak var petHotelImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(data: PetHotel){
        petHotelImageView.setImage(from: data.image)
        nameLabel.text = data.name
        descLabel.text = data.shortDesc
        distanceLabel.text = data.distance
    }
}
