//
//  UIViewController.swift
//  Wlif
//
//  Created by OSX on 13/07/2025.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    func navigate(to service: Services) {
        switch service {
        case .petStores:
            pushViewController(storyboardName: "Home", identifier: "PetsStoresViewController", type: PetsStoresViewController.self) { vc in
                vc.viewModel.serviceType = .petStores
            }
            
        case .veterinaryServices:
            pushViewController(storyboardName: "Home", identifier: "PetsStoresViewController", type: PetsStoresViewController.self) { vc in
                vc.viewModel.serviceType = .veterinaryServices
            }
            
        case .adoption:
            pushViewController(storyboardName: "Adoption", identifier: "AdoptionListViewController", type: AdoptionListViewController.self)
            
        case .petHotel:
            pushViewController(storyboardName: "PetHotel", identifier: "PetHotelsViewController", type: PetHotelsViewController.self)
            
        case .safePet:
            print("navigate to safe pet")
            
        case .insurance:
            print("navigate to insurance")
            
        case .unknown:
            print("navigate to unknown")
        }
    }
    
    private func pushViewController<T: UIViewController>(storyboardName: String, identifier: String, type: T.Type, configure: ((T) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            print("❌ Could not instantiate view controller with identifier: \(identifier) in storyboard: \(storyboardName)")
            return
        }
        configure?(vc)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigate<T: UIViewController>(to viewControllerType: T.Type,
                                           from storyboardName: String,
                                           storyboardID: String,
                                       animated: Bool = true) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: storyboardID) as? T else {
            assertionFailure("⚠️ Couldn't instantiate \(storyboardID) from \(storyboardName).storyboard")
            return
        }
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func displaySpinner(onView : UIView) -> UIView {
        let loaderColor = UIColor.label
        let animationFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100))
        let animationView = NVActivityIndicatorView(frame: animationFrame, type: NVActivityIndicatorType.ballPulse, color:loaderColor, padding: 10)
        DispatchQueue.main.async {
            animationView.center = onView.center
            onView.addSubview(animationView)
        }
        animationView.startAnimating()
        return animationView
    }
    
    func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    private struct SpinnerProperties {
        static var spinnerView: UIView?
    }
    
    func showLoadingIndicator() {
        guard SpinnerProperties.spinnerView == nil else { return }
        SpinnerProperties.spinnerView = displaySpinner(onView: self.view)
    }
    
    func hideLoadingIndicator() {
        if let sv = SpinnerProperties.spinnerView {
            removeSpinner(spinner: sv)
            SpinnerProperties.spinnerView = nil
        }
    }
}
