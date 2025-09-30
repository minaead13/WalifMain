//
//  UIFont.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import Foundation
import UIKit

extension UIViewController {
    func prepareAppFont(_ name:String) {
        UILabel.appearance().addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
        UILabel.appearance().substituteFontName = name
        UIButton.appearance().substituteFontName = name
        UITextView.appearance().substituteFontName = name
        UITextField.appearance().substituteFontName = name
    }
}

extension UILabel {
   
    func setLineHeight(lineHeight: CGFloat, hasSpacing: Bool = false) {
        let text = self.text
        
        if let text = text, self.tag != 888 {
            let attributeString = NSMutableAttributedString(string: text)
            
            let style = NSMutableParagraphStyle()
            style.alignment = LanguageManager.shared.isRightToLeft && self.textAlignment == .natural ? .right : !LanguageManager.shared.isRightToLeft && self.textAlignment == .natural ? .left : self.textAlignment
    
            if hasSpacing {
                style.lineSpacing = lineHeight
            }
           
            style.lineBreakMode = .byTruncatingTail
            let font = self.font ?? UIFont.systemFont(ofSize: lineHeight, weight: .medium)
            let range = NSRange(location: 0, length: text.count)
            attributeString.addAttribute(.font, value: font, range: range)
            attributeString.addAttribute(.foregroundColor, value: self.textColor ?? .black, range: NSMakeRange(0, text.count))
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            self.attributedText = attributeString
        }
    }
    
    @objc dynamic var substituteFontName: String? {
        
        get { return self.font.fontName }
        
        set {
            let fontNameToTest = self.font.fontName
            let sizeOfOldFont = self.font.pointSize
            var fontNameOfNewFont = ""
            var finalFontName = ""
            
            if self.font.fontName == "AppleColorEmoji" || self.font.fontName.contains("Arial") {
                self.setLineHeight(lineHeight: 4)//(sizeOfOldFont * 1.25) / 2)
                return
            } else if self.tag == 555 {
                return
            } else if self.tag == 777 {
                finalFontName = AppFontName.mono
            } else if fontNameToTest.range(of: "Bold") != nil || fontNameToTest.range(of: "bold") != nil {
                fontNameOfNewFont += "-Bold"
            } else if fontNameToTest.range(of: "Heavy") != nil || fontNameToTest.range(of: "heavy") != nil {
                fontNameOfNewFont += "-Bold"
            } else if fontNameToTest.range(of: "Semibold") != nil || fontNameToTest.range(of: "Md") != nil {
                fontNameOfNewFont += "-Semibold"
            } else if fontNameToTest.range(of: "Medium") != nil || fontNameToTest.range(of: "Md") != nil {
                fontNameOfNewFont += "-Medium"
            } else if fontNameToTest.range(of: "Regular") != nil{
                fontNameOfNewFont += "-Regular"
            } else if fontNameToTest.range(of: "light") != nil {
                fontNameOfNewFont += "-Regular"
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontNameOfNewFont += "-Regular"
            } else {
                fontNameOfNewFont = "-Regular"
            }
            
            if finalFontName.isEmpty {
                finalFontName = "\(newValue ?? "IBMPlexSansArabic")\(fontNameOfNewFont)"
            }
            
            if self.font.fontName != "FontAwesome", self.tag != 999 {
                self.font = UIFont(name: finalFontName , size: sizeOfOldFont)
                self.setLineHeight(lineHeight: sizeOfOldFont)
            }
        }
    }
}

extension UIButton{
    @objc dynamic var substituteFontName: String? {
        get { return self.titleLabel?.font.fontName }
        set {
            if let fontNameToTest = self.titleLabel?.font.fontName {
                let sizeOfOldFont = self.titleLabel?.font.pointSize
                var fontNameOfNewFont = ""
                var finalFontName = ""
                
                 if self.tag == 777 {
                   finalFontName = AppFontName.mono
               } else if fontNameToTest.range(of: "Bold") != nil || fontNameToTest.range(of: "bold") != nil {
                    fontNameOfNewFont += "-Medium"
                } else if fontNameToTest.range(of: "Heavy") != nil || fontNameToTest.range(of: "heavy") != nil {
                    fontNameOfNewFont += "-Medium"
                } else if fontNameToTest.range(of: "Semibold") != nil || fontNameToTest.range(of: "Md") != nil {
                    fontNameOfNewFont += "-Semibold"
                } else if fontNameToTest.range(of: "Medium") != nil || fontNameToTest.range(of: "Md") != nil {
                    fontNameOfNewFont += "-Medium"
                } else if fontNameToTest.range(of: "Regular") != nil{
                    fontNameOfNewFont += "-Light"
                } else if fontNameToTest.range(of: "light") != nil {
                    fontNameOfNewFont += "-Light"
                } else if fontNameToTest.range(of: "ultralight") != nil {
                    fontNameOfNewFont += "-Light"
                } else {
                    fontNameOfNewFont = "-Light"
                }
                
                if finalFontName.isEmpty {
                    finalFontName = "\(newValue ?? "IBMPlexSansArabic")\(fontNameOfNewFont)"
                }
                if self.titleLabel?.font.fontName != "FontAwesome" , self.tag != 999 {
                    self.titleLabel?.font = UIFont(name: finalFontName, size: sizeOfOldFont ?? 17)
                }
            }
            
        }
    }
}

extension UITextView {
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            
            let style = NSMutableParagraphStyle()
            style.alignment = LanguageManager.shared.isRightToLeft && self.textAlignment == .natural ? .right : !LanguageManager.shared.isRightToLeft && self.textAlignment == .natural ? .left : self.textAlignment
            //            style.colo
            //style.lineSpacing = lineHeight
            style.lineBreakMode = .byTruncatingTail
            let font = self.font ?? UIFont.systemFont(ofSize: lineHeight, weight: .medium)
            let range = NSRange(location: 0, length: text.count)
            attributeString.addAttribute(.font, value: font, range: range)
            attributeString.addAttribute(.foregroundColor, value: self.textColor ?? .black, range: NSMakeRange(0, text.count))
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            self.attributedText = attributeString
        }
    }
    
    @objc dynamic var substituteFontName: String? {
        get { return self.font?.fontName }
        set {
            if let fontNameToTest = self.font?.fontName {
                let sizeOfOldFont = self.font?.pointSize
                var fontNameOfNewFont = ""
                
                if fontNameToTest.range(of: "Bold") != nil || fontNameToTest.range(of: "bold") != nil {
                    fontNameOfNewFont += "-Medium"
                } else if fontNameToTest.range(of: "Heavy") != nil || fontNameToTest.range(of: "heavy") != nil {
                    fontNameOfNewFont += "-Medium"
                } else if fontNameToTest.range(of: "Semibold") != nil || fontNameToTest.range(of: "Md") != nil {
                    fontNameOfNewFont += "-Semibold"
                } else if fontNameToTest.range(of: "Medium") != nil || fontNameToTest.range(of: "Md") != nil {
                    fontNameOfNewFont += "-Medium"
                } else if fontNameToTest.range(of: "Regular") != nil{
                    fontNameOfNewFont += "-Light"
                } else if fontNameToTest.range(of: "light") != nil {
                    fontNameOfNewFont += "-Light"
                } else if fontNameToTest.range(of: "ultralight") != nil {
                    fontNameOfNewFont += "-Light"
                } else {
                    fontNameOfNewFont = "-Light"
                }
                let font = "\(newValue ?? "IBMPlexSansArabic")\(fontNameOfNewFont)"
                
                if fontNameToTest != "FontAwesome", self.tag != 999 {
                    self.font = UIFont(name: font, size: sizeOfOldFont ?? 17)
                    self.setLineHeight(lineHeight: (sizeOfOldFont ?? 17))
                }
            }
        }
    }
}

extension UITextField {
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            
            let style = NSMutableParagraphStyle()
            style.alignment = LanguageManager.shared.isRightToLeft && self.textAlignment == .natural ? .right : !LanguageManager.shared.isRightToLeft && self.textAlignment == .natural ? .left : self.textAlignment
            //            style.colo
            //style.lineSpacing = lineHeight
            style.lineBreakMode = .byTruncatingTail
            let font = self.font ?? UIFont.systemFont(ofSize: lineHeight, weight: .medium)
            let range = NSRange(location: 0, length: text.count)
            attributeString.addAttribute(.font, value: font, range: range)
            attributeString.addAttribute(.foregroundColor, value: self.textColor ?? .black, range: NSMakeRange(0, text.count))
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            self.attributedText = attributeString
        }
    }
    
    @objc dynamic var substituteFontName: String? {
        get { return self.font?.fontName }
        set {
            if let fontNameToTest = self.font?.fontName {
                let sizeOfOldFont = self.font?.pointSize
                var fontNameOfNewFont = ""
                
                if fontNameToTest.range(of: "Bold") != nil || fontNameToTest.range(of: "bold") != nil {
                    fontNameOfNewFont += "-Medium"
                } else if fontNameToTest.range(of: "Heavy") != nil || fontNameToTest.range(of: "heavy") != nil {
                    fontNameOfNewFont += "-Medium"
                } else if fontNameToTest.range(of: "Semibold") != nil || fontNameToTest.range(of: "Md") != nil {
                    fontNameOfNewFont += "-Semibold"
                } else if fontNameToTest.range(of: "Medium") != nil || fontNameToTest.range(of: "Md") != nil {
                    fontNameOfNewFont += "-Medium"
                } else if fontNameToTest.range(of: "Regular") != nil{
                    fontNameOfNewFont += "-Light"
                } else if fontNameToTest.range(of: "light") != nil {
                    fontNameOfNewFont += "-Light"
                } else if fontNameToTest.range(of: "ultralight") != nil {
                    fontNameOfNewFont += "-Light"
                } else {
                    fontNameOfNewFont = "-Light"
                }
                let font = "\(newValue ?? "IBMPlexSansArabic")\(fontNameOfNewFont)"
                
                if fontNameToTest != "FontAwesome", self.tag != 999 {
                    self.font = UIFont(name: font, size: sizeOfOldFont ?? 17)
                    self.setLineHeight(lineHeight: (sizeOfOldFont ?? 17))
                }
            }
        }
    }
}

//extension UINavigationBar {
//    @objc dynamic var substituteFontName: String? {
//        get { return self.topItem?.titleLabel.font?.fontName }
//        set {
//            if let fontNameToTest = self.topItem?.titleLabel.font?.fontName {
//                let sizeOfOldFont = self.topItem?.titleLabel.font?.pointSize
//                var fontNameOfNewFont = ""
//                
//                if fontNameToTest.range(of: "Bold") != nil || fontNameToTest.range(of: "bold") != nil {
//                    fontNameOfNewFont += "-Medium"
//                } else if fontNameToTest.range(of: "Heavy") != nil || fontNameToTest.range(of: "heavy") != nil {
//                    fontNameOfNewFont += "-Medium"
//                } else if fontNameToTest.range(of: "Semibold") != nil || fontNameToTest.range(of: "Md") != nil {
//                    fontNameOfNewFont += "-Medium"
//                } else if fontNameToTest.range(of: "Medium") != nil || fontNameToTest.range(of: "Md") != nil {
//                    fontNameOfNewFont += "-Medium"
//                } else if fontNameToTest.range(of: "Regular") != nil{
//                    fontNameOfNewFont += "-Light"
//                } else if fontNameToTest.range(of: "light") != nil {
//                    fontNameOfNewFont += "-Light"
//                } else if fontNameToTest.range(of: "ultralight") != nil {
//                    fontNameOfNewFont += "-Light"
//                } else {
//                    fontNameOfNewFont = "-Light"
//                }
//                let font = "\(newValue ?? "IBMPlexSansArabic")\(fontNameOfNewFont)"
//                
//                if fontNameToTest != "FontAwesome" , self.tag != 999 {
//                    self.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: font, size: sizeOfOldFont ?? 24)!]
//                    self.topItem?.titleLabel.font = UIFont(name: font, size: sizeOfOldFont ?? 17)
//                }
//            }
//        }
//    }
//}

struct AppFontName {
    static let regular = "IBMPlexSansArabic-Regular"
    static let bold = "IBMPlexSansArabic-Bold"
    static let medium = "IBMPlexSansArabic-Medium"
    static let semiBold = "IBMPlexSansArabic-SemiBold"
    static let mono = "IBMPlexMono-Bold"
}



extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size) ?? UIFont(name: AppFontName.regular, size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    @objc class func myMediumSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }
    
    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }
    
    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
            self.init(myCoder: aDecoder)
            return
        }
        
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = AppFontName.regular
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = AppFontName.bold
        case "CTFontMediumUsage":
            fontName = AppFontName.regular
        case "CTFontObliqueUsage":
            fontName = AppFontName.regular
        default:
            fontName = AppFontName.regular
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }
    
    class func overrideInitialize() {
        guard self == UIFont.self else { return }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
           let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
           let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
           let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }
        
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
           let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}
