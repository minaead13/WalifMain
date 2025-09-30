//
//  InfoTableViewCell.swift
//  Wlif
//
//  Created by OSX on 02/09/2025.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(info: OrderDetailsModel, slogan: Services) {
        titleLabel.text = slogan == .veterinaryServices ? "Clinic Information :".localized : "Hotel Information :".localized
        infoImageView.setImage(from: info.merchantImage)
        nameLabel.text = info.merchantName
        rateLabel.text = "\( info.merchantRate ?? 0)"
    }

}
