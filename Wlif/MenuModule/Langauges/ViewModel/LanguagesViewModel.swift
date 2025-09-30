//
//  LanguageViewModel.swift
//  Wlif
//
//  Created by OSX on 11/08/2025.
//

import Foundation

class LanguagesViewModel {
    
    var selectedIndex = LanguageManager.shared.currentLanguage == .arSa ? 0 : 1
    var languages = ["العربية", "English"]
}
