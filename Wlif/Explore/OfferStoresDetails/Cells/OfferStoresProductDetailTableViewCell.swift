//
//  OfferStoresProductDetailTableViewCell.swift
//  Wlif
//
//  Created by OSX on 17/08/2025.
//

import UIKit

class OfferStoresProductDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    
    var updateQnty: (()-> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: OfferStoresDetailsModel) {
        productImageView.setImage(from: data.image)
        nameLabel.text = data.name
        priceLabel.text = "\(data.price ?? 0)"
        oldPriceLabel.text = "\(data.priceBefore ?? 0)"
    }

    
    @IBAction func didTapAddBtn(_ sender: Any) {
        updateQnty?()
    }
    
}
