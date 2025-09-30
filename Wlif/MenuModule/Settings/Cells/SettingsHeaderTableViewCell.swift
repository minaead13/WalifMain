//
//  SettingsHeaderTableViewCell.swift
//  Wlif
//
//  Created by OSX on 05/08/2025.
//

import UIKit

class SettingsHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var actionsView: UIView!
    
    var handleProfileSelection: (() -> Void)?
    var handleFavSelection: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = UserUtil.load()?.user?.name
        userImageView.image = UIImage(named: UserUtil.load()?.user?.image ?? "")
        
    }
    
    @IBAction func didTapProfileBtn(_ sender: Any) {
        handleProfileSelection?()
    }
    
    
    @IBAction func didTapFavBtn(_ sender: Any) {
        handleFavSelection?()
    }
    
}
