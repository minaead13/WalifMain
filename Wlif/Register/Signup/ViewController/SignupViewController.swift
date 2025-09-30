//
//  SignupViewController.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextFeild: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    
    private lazy var validator = LoginValidator()
    lazy var viewModel = SignupViewModel(validator: validator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        bind()
    }
    
    func bind() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self,
                  let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self.showLoadingIndicator()
                } else {
                    self.hideLoadingIndicator()
                }
            }
        }
    }
    
    func register() {
        
        signupButton.isEnabled = false
        errorLabel.isHidden = true
        errorLabel.text = ""
        
        viewModel.register(fullName: fullnameTextField.text ?? "", phone: phoneTextField.text ?? "", email: emailTextFeild.text ?? "") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                    vc.otpViewModel.userData = data.user
                    self?.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    self?.errorLabel.isHidden = false
                    self?.errorLabel.text = error.localizedDescription
                }
                self?.signupButton.isEnabled = true
            }
        }
    }

    @IBAction func didTapSignupButton(_ sender: Any) {
        register()
    }
    

}
