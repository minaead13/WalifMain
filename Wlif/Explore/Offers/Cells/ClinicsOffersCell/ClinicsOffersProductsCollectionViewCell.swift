//
//  ClinicsOffersProductsCollectionViewCell.swift
//  Wlif
//
//  Created by OSX on 14/08/2025.
//

import UIKit

class ClinicsOffersProductsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var discountPercentageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceBeforLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configure(with data: ClinicOffer) {
        nameLabel.text = data.name
        nameLabel.setLineHeight(lineHeight: 12)
        discountPercentageLabel.text = "\("Discount".localized) \(data.discountPercentage ?? 0)%"
        priceLabel.text = "\(data.price ?? 0)"
        priceBeforLabel.text = "\(data.oldPrice ?? 0)"
    }
    
    func configure(with data: StoreOffers) {
        nameLabel.text = data.name
        nameLabel.setLineHeight(lineHeight: 12)
        discountPercentageLabel.text = "\("Discount".localized) \(data.discountPercentage ?? 0)%"
        priceLabel.text = "\(data.price ?? 0)"
        priceBeforLabel.text = "\(data.priceBefore ?? 0)"
    }
    
    

}
