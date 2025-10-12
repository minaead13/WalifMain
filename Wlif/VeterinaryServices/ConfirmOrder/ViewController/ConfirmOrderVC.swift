//
//  ConfirmOrderVC.swift
//  Wlif
//
//  Created by OSX on 23/07/2025.
//

import UIKit

class ConfirmOrderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func didTapGoToHome(_ sender: Any) {
        if let firstViewController = navigationController?.viewControllers.first {
            navigationController?.popToViewController(firstViewController, animated: true)
        }
    }
    
    @IBAction func didTapOrderDetails(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Orders", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OrderHistoryViewController") as! OrderHistoryViewController
        vc.viewModel.isFromSuccessScreen = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
