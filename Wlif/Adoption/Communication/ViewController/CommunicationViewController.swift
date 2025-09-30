//
//  CommunicationViewController.swift
//  Wlif
//
//  Created by OSX on 14/07/2025.
//

import UIKit

class CommunicationViewController: UIViewController {
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    let viewModel = CommunicationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
    }
    
    func setupUI() {
        phoneLabel.text = viewModel.phoneNumber
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
   
    @IBAction func didTapPhoneBtn(_ sender: Any) {
        let phone = viewModel.phoneNumber.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "tel://\(phone)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func didTapCommunicateBtn(_ sender: Any) {
        
    }
    
    
    @IBAction func didTapDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
