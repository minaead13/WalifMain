//
//  AdoptedPetsCollectionViewCell.swift
//  Wlif
//
//  Created by OSX on 27/07/2025.
//

import UIKit

class AdoptedPetsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: MyAnimalModel) {
        petImageView.setImage(from: data.image)
        nameLabel.text = data.petName
        descLabel.text = data.description
    }
}
