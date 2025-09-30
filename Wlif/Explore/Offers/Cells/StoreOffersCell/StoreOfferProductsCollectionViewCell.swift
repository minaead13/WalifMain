//
//  StoreOfferProductsCollectionViewCell.swift
//  Wlif
//
//  Created by OSX on 13/08/2025.
//

import UIKit

class StoreOfferProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var discountPercentageLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceBeforLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configure(with data: StoreOffers) {
        discountPercentageLabel.text = "\("Discount".localized) \(data.discountPercentage ?? 0)%"
        storeImageView.setImage(from: data.image)
        nameLabel.text = data.name
        priceLabel.text = "\(data.price ?? 0)"
        priceBeforLabel.text = "\(data.priceBefore ?? 0)"
    }
   

}
