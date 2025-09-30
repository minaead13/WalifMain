//
//  PaymentInfoTableViewCell.swift
//  Wlif
//
//  Created by OSX on 23/07/2025.
//

import UIKit

class PaymentInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
