//
//  UIImage.swift
//  Wlif
//
//  Created by OSX on 13/07/2025.
//

import UIKit

extension UIImageView {
    
    func setImage(from urlString: String?, placeholder: String = "placeholderImage") {
        let placeholderImage = UIImage(named: placeholder)
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = placeholderImage
            return
        }
        self.kf.setImage(with: url, placeholder: placeholderImage)
    }
}
