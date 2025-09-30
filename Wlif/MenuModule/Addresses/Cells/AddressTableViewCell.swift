//
//  AddressTableViewCell.swift
//  Wlif
//
//  Created by OSX on 11/08/2025.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var handleSelection: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with data: AddressModel) {
        typeLabel.text = data.type
        addressLabel.text = data.address
    }

    @IBAction func didTapDeleteBtn(_ sender: Any) {
        handleSelection?()
    }
    
    
}
