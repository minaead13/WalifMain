//
//  LoginViewController.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var outerStack: UIStackView!
    @IBOutlet weak var loginStack: UIStackView!
    @IBOutlet weak var mobileNumberStack: UIStackView!
    
    
    private lazy var validator = LoginValidator()
    private lazy var viewModel = LoginViewModel(validator: validator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
    func setUI() {
        outerStack.semanticContentAttribute = .forceLeftToRight
        loginStack.semanticContentAttribute = .forceLeftToRight
        mobileNumberStack.semanticContentAttribute = .forceLeftToRight
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

    func login() {
        
        loginButton.isEnabled = false
        
        errorMessage.text = ""
        
        viewModel.processLogin(mobileNumber: numberTextField.text ?? "") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self?.navigateToHome(isNewUser: result.newUser ?? false)
                case .failure(let error):
                    self?.errorMessage.text = error.localizedDescription
                }
                self?.loginButton.isEnabled = true
            }
        }
    }
    
    func navigateToHome(isNewUser: Bool) {
        if isNewUser {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
            vc.otpViewModel.userData = viewModel.userData
            self.navigationController?.pushViewController(vc, animated: true)
        }
      
    }
    
    @IBAction func didTapLoginBtn(_ sender: Any) {
        login()
    }
}

