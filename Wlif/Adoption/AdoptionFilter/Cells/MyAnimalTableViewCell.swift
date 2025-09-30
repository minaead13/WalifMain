//
//  MyAnimalTableViewCell.swift
//  Wlif
//
//  Created by OSX on 27/07/2025.
//

import UIKit

class MyAnimalTableViewCell: UITableViewCell {

    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var adoptedView: UIView!
    
    var handleSelection: (() -> Void)?
    var handleDeleteSelection: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(data: MyAnimalModel) {
        animalImageView.setImage(from: data.image)
        nameLabel.text = data.petName
        descLabel.text = data.description
        adoptedView.isHidden = !(data.adopted == true)
    }
    
    @IBAction func didTapEditButton(_ sender: Any) {
        handleSelection?()
    }
    
    @IBAction func didTapDeleteBtn(_ sender: Any) {
        handleDeleteSelection?()
    }
    
}
