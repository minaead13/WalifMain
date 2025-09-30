//
//  SettingsViewModel.swift
//  Wlif
//
//  Created by OSX on 05/08/2025.
//

import Foundation

class SettingsViewModel {
    
    var settingsArray = [
        SettingsModel(image: "OrderHistory", name: "Order History".localized),
        SettingsModel(image: "paymentMethod", name: "Payment Methods".localized),
        SettingsModel(image: "support", name: "Support".localized),
        SettingsModel(image: "language", name: "Language".localized),
        SettingsModel(image: "Terms", name: "Terms and Conditions".localized),
        SettingsModel(image: "ShareApp", name: "Share App".localized),
        SettingsModel(image: "Rate", name: "Rate App".localized),
        SettingsModel(image: "Wallet", name: "Wallet".localized),
        
    ]
    
    var profileArray = [
        SettingsModel(image: "PersonalInfo", name: "Personal Information".localized),
        SettingsModel(image: "ShippingAddress", name: "Shipping Address".localized),
        SettingsModel(image: "Logout", name: "Logout".localized),
        SettingsModel(image: "deleteAcc", name: "Delete Account".localized)
    ]
}
