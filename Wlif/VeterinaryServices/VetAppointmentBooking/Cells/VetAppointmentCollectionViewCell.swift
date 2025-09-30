//
//  VetAppointmentCollectionViewCell.swift
//  Wlif
//
//  Created by OSX on 21/07/2025.
//

import UIKit

class VetAppointmentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setColor(isSelected: Bool) {
        backView.borderWidth = 1
        
        if isSelected {
            let highlightColor = UIColor(red: 223/255, green: 255/255, blue: 50/255, alpha: 1)
            backView.backgroundColor = highlightColor.withAlphaComponent(0.21)
            backView.borderColor = highlightColor
        } else {
            backView.backgroundColor = .white
            backView.borderColor = UIColor(hex: "E9E9E9")
        }
    }

}

