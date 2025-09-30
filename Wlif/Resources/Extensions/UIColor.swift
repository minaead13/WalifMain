//
//  UIColor.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import UIKit

extension UIColor {
    
    static var mainColor: UIColor {
        return UIColor(hex: "00CD7C")
    }
    static var customBlue: UIColor {
        return UIColor(hex: "3497FC")
    }
    static var customGreen: UIColor {
        return UIColor(hex: "00CD7C")
    }
    static var customGreenAlpha: UIColor {
        return UIColor(hex: "00CD7C",alpha: 0.1)
    }
    static var customBlueAlpha: UIColor {
        return UIColor(hex: "E5F8FF",alpha: 0.1)
    }
    static var customPaleRedAlpha: UIColor {
        return UIColor(hex: "f03c2e",alpha: 0.1)
    }
    static var customYellow: UIColor {
        return UIColor(hex: "E7BB48")
    }
    static var customPaleRed: UIColor {
        return UIColor(hex: "f03c2e")
    }
    static var customYellowDark: UIColor {
        return UIColor(hex: "CC8956")
    }
    static var customGray: UIColor {
        return UIColor(hex: "C0C0C0")
    }
    static var brownGrey: UIColor {
        return UIColor(hex: "707070")
    }
    static var customTextGray: UIColor {
        return UIColor(hex: "878787")
    }
    static var customOffWhite: UIColor {
        return UIColor(hex: "EAEAEA")
    }
    static var backgroundColor: UIColor {
        return UIColor(hex: "F6F6F6")
    }
    
    static var unselectedTabBar: UIColor {
        return UIColor(hex: "979797")
    }
    
    static var laterFlowTypeColor: UIColor {
        return UIColor(hex: "00AEEF")
    }
    
    static var insuranceFlowTypeColor: UIColor {
        return UIColor(hex: "F89C0E")
    }

    static var currentFlowTypebackGroundColor: UIColor {
        //if UserDefaults.standard.string(forKey: "flow-type") == "now" {
            return UIColor(hex: "00CD7C")
//        } else {
//            return UIColor(hex: "E5F8FF")
//        }
    }

    static var currentFlowTypeAlpha: UIColor {
       // if UserDefaults.standard.string(forKey: "flow-type") == "now" {
            return customGreenAlpha
//        } else {
//            return customBlueAlpha
//        }
    }

    static var currentFlowTypeColor: UIColor {
        return UIColor(hex: "00CE7C")
    }
    
    func isEqualTo(_ color: UIColor) -> Bool {
        var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
        getRed(&red1, green:&green1, blue:&blue1, alpha:&alpha1)
        
        var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0
        color.getRed(&red2, green:&green2, blue:&blue2, alpha:&alpha2)
        
        return red1 == red2 && green1 == green2 && blue1 == blue2 && alpha1 == alpha2
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol.removeFirst()
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.count) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
