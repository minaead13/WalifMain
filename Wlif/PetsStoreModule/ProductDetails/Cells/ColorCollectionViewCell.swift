//
//  ColorCollectionViewCell.swift
//  Wlif
//
//  Created by OSX on 09/07/2025.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.cornerRadius = colorView.frame.width / 2
    }

}
