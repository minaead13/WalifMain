//
//  WalletTableViewCell.swift
//  Wlif
//
//  Created by OSX on 27/08/2025.
//

import UIKit

class WalletTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(data: Transaction) {
        titleLabel.text = data.title
        createdAtLabel.text = data.createdAt
        amountLabel.text = data.amount
    }
    
}
