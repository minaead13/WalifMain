//
//  AppDelegate.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import UIKit
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import GoogleMaps
//import CheckoutSDK_iOS

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setup()
        GMSServices.provideAPIKey("AIzaSyBCXn9fjD1eSTVPsnx6yK5-WRgT7ePg4x0")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setup() {
        setAppLanguage()
        keyboardManagerSetup()
        prepareAppFont("IBMPlexSansArabic")
        setPayment()
    }
    
    func setAppLanguage() {
        if (UserDefaults.standard.string(forKey: "selectedLanguage") ?? "").contains("ar") {
            LanguageManager.shared.defaultLanguage = .arSa
            LanguageManager.shared.setLanguage(language: .arSa)
        } else {
            LanguageManager.shared.defaultLanguage = .en
            LanguageManager.shared.setLanguage(language: .en)
        }
    }
  
    func keyboardManagerSetup() {
        
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardToolbarManager.shared.isEnabled = false
        
    }

    func prepareAppFont(_ name:String) {
        UILabel
            .appearance()
            .substituteFontName
        = name
        
        UIButton
            .appearance()
            .substituteFontName
        = name
        
        UITextView
            .appearance()
            .substituteFontName
        = name
        
        UITextField
            .appearance()
            .substituteFontName
        = name
    
    }
    
    func setPayment() {
//        let config = CheckoutConfig(
//            publicKey: "pk_test_dLHQbnGpZag4Fk9sYu3X6zl0",
//            merchantId: "YOUR_MERCHANT_ID",
//            environment: .sandbox
//        )
//        
//        TapCheckoutSDK.initializeSDK(
//                    publicKey: "YOUR_PUBLIC_KEY",
//                    bundleID: Bundle.main.bundleIdentifier ?? ""
//                )
        //CheckoutSDK.initalizeSdk
    }
}

