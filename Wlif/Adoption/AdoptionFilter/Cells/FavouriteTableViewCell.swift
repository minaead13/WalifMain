//
//  FavouriteTableViewCell.swift
//  Wlif
//
//  Created by OSX on 28/07/2025.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var handleSelection: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: FavModel) {
        animalImageView.setImage(from: data.image)
        nameLabel.text = data.petName
        descLabel.text = data.description
    }

    @IBAction func didTapDeleteBtn(_ sender: Any) {
        handleSelection?()
    }
    
    
}
