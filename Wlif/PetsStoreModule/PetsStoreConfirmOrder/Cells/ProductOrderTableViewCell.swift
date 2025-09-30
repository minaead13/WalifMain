//
//  ProductOrderTableViewCell.swift
//  Wlif
//
//  Created by OSX on 03/08/2025.
//

import UIKit

class ProductOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(item: Item) {
        storeImageView.setImage(from: item.image)
        nameLabel.text = item.name
        storeLabel.text = item.store
        sizeLabel.text = item.size
        priceLabel.text = "\(item.price ?? 0)"
        quantityLabel.text = "\(item.qty ?? 0)"
    }
}
