//
//  PaymentMethodTableViewCell.swift
//  Wlif
//
//  Created by OSX on 23/07/2025.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var paymentLabel: UILabel!
    
    var completionHandler: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didTapOpenPaymentMethods(_ sender: Any) {
        completionHandler?()
    }
    
   
    
}
