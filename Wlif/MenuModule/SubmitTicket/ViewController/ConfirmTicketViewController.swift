//
//  ConfirmTicketViewController.swift
//  Wlif
//
//  Created by OSX on 10/08/2025.
//

import UIKit

class ConfirmTicketViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
  
    @IBAction func didTapGoToHome(_ sender: Any) {
        if let firstViewController = navigationController?.viewControllers.first {
            navigationController?.popToViewController(firstViewController, animated: true)
        }
    }

}
