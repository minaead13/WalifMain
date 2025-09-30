//
//  ProductTableViewCell.swift
//  Wlif
//
//  Created by OSX on 08/07/2025.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    
    var qtyAmount: Int = 0 {
        didSet {
            qtyLabel.text = "\(qtyAmount)"
            minusBtn.isHidden = qtyAmount <= 0
        }
    }
    
    var updateQnty: ((_ action: QtyAction,_ qnty: Int)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    func config(data: Product) {
        if let urlString = data.image,
           let url = URL(string: urlString) {
            productImageView.kf.setImage(with: url)
        }
        nameLabel.text = data.name
        priceLabel.text = "\(data.price ?? 0)"
    }
    
    
    @IBAction func didTapAddButton(_ sender: Any) {
        qtyAmount += 1
        updateQnty?(.increase, qtyAmount)
    }
    
    
    
    @IBAction func didTapMinusButton(_ sender: Any) {
        qtyAmount -= 1
        updateQnty?(.decrease, qtyAmount)
    }
}

enum QtyAction {
    case increase
    case decrease
    case delete
}
