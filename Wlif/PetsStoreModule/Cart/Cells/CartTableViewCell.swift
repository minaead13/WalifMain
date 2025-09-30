//
//  CartTableViewCell.swift
//  Wlif
//
//  Created by OSX on 10/07/2025.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    
    var item: Item? {
        didSet {
            if let urlString = item?.image,
               let url = URL(string: urlString) {
                itemImageView.kf.setImage(with: url)
            }
            
            nameLabel.text = item?.name ?? ""
            storeLabel.text = item?.store ?? ""
            sizeLabel.text = item?.size
            priceLabel.text = "\(item?.price ?? 0)"
           // qtyLabel.text = "\(item?.qty ?? 0)"
            
            qtyAmount = item?.qty ?? 0
        }
    }
    
    var qtyAmount: Int = 0 {
        didSet {
            qtyLabel.text = "\(qtyAmount)"
            minusBtn.isEnabled = !(qtyAmount <= 0)
        }
    }
    
    var updateQnty: ((_ action: QtyAction,_ qnty: Int)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    
    @IBAction func didTapMinusBtn(_ sender: Any) {
        guard let currentQty = item?.qty else { return }
        let newQty = currentQty - 1
        if newQty <= 0 {
            updateQnty?(.delete, newQty)
        } else {
            
            updateQnty?(.decrease, newQty)
        }
    }
    
    @IBAction func didTapAddBtn(_ sender: Any) {
        guard let currentQty = item?.qty else { return }
        print("newQty is before \(currentQty)")
        let newQty = currentQty + 1
        print("newQty is after \(newQty)")
        updateQnty?(.increase, newQty)
    }
}
