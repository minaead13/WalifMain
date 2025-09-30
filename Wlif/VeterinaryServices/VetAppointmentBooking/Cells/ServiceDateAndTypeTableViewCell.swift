//
//  ServiceDateAndTypeTableViewCell.swift
//  Wlif
//
//  Created by OSX on 21/07/2025.
//

import UIKit

class ServiceDateAndTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var serviceType: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var handleSelection: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapOpenCalender(_ sender: Any) {
        handleSelection?()
    }
    
    
}
