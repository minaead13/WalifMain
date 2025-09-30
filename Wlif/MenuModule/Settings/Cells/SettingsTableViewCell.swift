//
//  SettingsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 05/08/2025.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var settinsImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var backgroundImageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
