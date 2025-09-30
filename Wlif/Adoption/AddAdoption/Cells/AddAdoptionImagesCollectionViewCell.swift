//
//  AddAdoptionImagesCollectionViewCell.swift
//  Wlif
//
//  Created by OSX on 15/07/2025.
//

import UIKit

class AddAdoptionImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var addImageView: UIImageView!
    
    
    var handleDeleteBtn: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func removeBtnTapped(_ sender: Any) {
        handleDeleteBtn?()
    }

}
