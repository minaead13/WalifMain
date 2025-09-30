//
//  ServiceCollectionViewCell.swift
//  Wlif
//
//  Created by OSX on 03/07/2025.
//

import UIKit

class ServiceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var bookView: UIView!
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    var handleSelection: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    func setData(service: HomeService) {
        serviceImageView.setImage(from: service.image)
        serviceLabel.text = service.name
                
        let type = Services(rawValue: service.slogan ?? "") ?? .unknown
        
        if type == .petHotel {
            serviceLabel.textColor = .white
            bookLabel.textColor = .black
            bookImage.image = UIImage(named: "arrowHomeBlack")
        }
        
        outerView.backgroundColor = type.backgroundColor
        bookView.backgroundColor = type.bookViewColor
    }
    
    
    @IBAction func didTapBookBtn(_ sender: Any) {
        handleSelection?()
    }
}
