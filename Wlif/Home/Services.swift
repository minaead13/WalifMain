//
//  Services.swift
//  Wlif
//
//  Created by OSX on 13/07/2025.
//

import Foundation
import UIKit

enum Services: String {
    case petStores
    case veterinaryServices
    case adoption
    case petHotel
    case safePet
    case insurance
    case unknown
    
    init(from rawValue: String) {
        self = Services(rawValue: rawValue) ?? .unknown
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .petStores: return UIColor(hexString: "FFFFFF")
        case .veterinaryServices: return UIColor(hexString: "BEE2F2")
        case .adoption: return UIColor(hexString: "DFFF32")
        case .petHotel: return UIColor(hexString: "0F0F0F")
        case .safePet: return UIColor(hexString: "E9E9E9")
        case .insurance: return UIColor(hexString: "FFFFFF")
        case .unknown: return .clear
        }
    }
    
    var bookViewColor: UIColor {
        switch self {
        case .petHotel: return UIColor(hexString: "F5F7F2")
        default: return .black
        }
    }
}
