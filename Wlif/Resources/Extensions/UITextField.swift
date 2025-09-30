//
//  UITextField.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import UIKit

var isPressed:Bool = true
extension UITextField {
    @IBInspectable
    var placeholderColor: UIColor {
        get {
            guard let currentAttributedPlaceholderColor = attributedPlaceholder?.attribute(NSAttributedString.Key.foregroundColor, at: 0, effectiveRange: nil) as? UIColor else { return UIColor.clear }
            return currentAttributedPlaceholderColor
        }
        set {
            guard let currentAttributedString = attributedPlaceholder else { return }
            let attributes = [NSAttributedString.Key.foregroundColor : newValue]
            attributedPlaceholder = NSAttributedString(string: currentAttributedString.string, attributes: attributes)
        }
    }
    @IBInspectable
    var padding: CGFloat {
        get {
            return 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.height))
            leftView = paddingView
            leftViewMode = .always
            rightView = paddingView
            rightViewMode = .always
        }
    }
    /* if UITextField Password */
    @IBInspectable
    var isPassword: Bool {
        set {
            if newValue {
                self.isSecureTextEntry = true
                
                let imageView = UIImageView(frame: CGRect(x: 0, y: 16, width: 24, height: 24))
                imageView.image = UIImage(named: "ic_hiddenPass")
                
                let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 56))
                imageContainerView.addSubview(imageView)
                rightView = imageContainerView
                rightViewMode = .always
                if #available(iOS 15.0, *) {
                    imageView.tintColor = UIColor.white
                } else {
                    imageView.tintColor = placeholderColor
                }
                imageView.contentMode = .scaleAspectFit
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(tapGestureRecognizer)
                
            }
        }
        get {
            return self.isPassword
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        isPressed = !isPressed
        if isPressed {
            tappedImage.image = #imageLiteral(resourceName: "ic_hiddenPass")
            self.isSecureTextEntry = true
        } else {
            tappedImage.image = #imageLiteral(resourceName: "ic_showPass")
            self.isSecureTextEntry = false
        }
    }
    
    @IBInspectable
    var requiredImage: UIImage? {
        get {
            return nil
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            let imageView = UIImageView(frame: CGRect(x: 4, y: 4, width: 8, height: 8))
            imageView.image = newValue
            imageView.contentMode = .scaleAspectFit
            paddingView.addSubview(imageView)
            leftView = paddingView
            leftViewMode = .always
        }
    }
    @IBInspectable
    var leftImage: UIImage? { // ar
        get {
            return nil
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 48))
            let imageView = UIImageView(frame: CGRect(x: 0, y: 9, width: 25, height: 32))
            if #available(iOS 15.0, *) {
                imageView.tintColor = UIColor.tintColor
            } else {
                imageView.tintColor = placeholderColor
            }
            imageView.image = newValue
            imageView.contentMode = .center
            imageView.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.addGestureRecognizer(tapGestureRecognizer)
            paddingView.addSubview(imageView)
            leftView = paddingView
            leftViewMode = .always
        }
    }
    @IBInspectable
    var rightImage: UIImage? {
        get {
            return nil
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 48))
            let imageView = UIImageView(frame: CGRect(x: 0, y: 9, width: 25, height: 32))
            imageView.tintColor = placeholderColor
            imageView.image = newValue
            imageView.contentMode = .center
            imageView.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.addGestureRecognizer(tapGestureRecognizer)
            paddingView.addSubview(imageView)
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        self.becomeFirstResponder()
    }
    
}

