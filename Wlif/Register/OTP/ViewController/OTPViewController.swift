//
//  OTPViewController.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import UIKit

class OTPViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var otp1TextField: UITextField!
    @IBOutlet weak var otp2TextField: UITextField!
    @IBOutlet weak var otp3TextField: UITextField!
    @IBOutlet weak var otp4TextField: UITextField!
    @IBOutlet weak var otpStack: UIStackView!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var outerStack: UIStackView!
    @IBOutlet weak var phoneLabel: UILabel!
    
    private lazy var validator = LoginValidator()
    lazy var viewModel = LoginViewModel(validator: validator)
    let otpViewModel = OTPViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.resendButton.isEnabled = false
        setupTextFieldDelegates()
        setupBindings()
        otpStack.semanticContentAttribute = .forceLeftToRight
        outerStack.semanticContentAttribute = .forceLeftToRight
        phoneLabel.text = otpViewModel.userData?.phone
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
    
    func setupBindings() {
        otpViewModel.delegate = self
    }
    
    private func setupTextFieldDelegates(){
        otp1TextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        otp2TextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        otp3TextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        otp4TextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        otp1TextField.tag = 1
        otp2TextField.tag = 2
        otp3TextField.tag = 3
        otp4TextField.tag = 4

        otp1TextField.delegate = self
        otp2TextField.delegate = self
        otp3TextField.delegate = self
        otp4TextField.delegate = self
    }
    
    
    @objc private func textDidChange(textfield: UITextField) {
        let text = textfield.text

        if text?.count == 1 {
            let nextTag = textfield.tag + 1
            if let nextResponder = textfield.superview?.viewWithTag(nextTag) as? UITextField {
                nextResponder.becomeFirstResponder()
            }
        } else if text?.count == 0 {
            let previousTag = textfield.tag - 1
            if let previousResponder = textfield.superview?.viewWithTag(previousTag) as? UITextField {
                previousResponder.becomeFirstResponder()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789")
        let characterSet = CharacterSet(charactersIn: newText)
        return allowedCharacters.isSuperset(of: characterSet) && newText.count <= 1
    }
    
    func verify() {
        
        verifyButton.isEnabled = false
        errorLabel.isHidden = true
        errorLabel.text = ""
        
        let otpString = [otp1TextField, otp2TextField, otp3TextField, otp4TextField]
            .compactMap { $0.text }
            .joined()
            .replacedArabicDigitsWithEnglish
       
        viewModel.verify(phone: otpViewModel.userData?.phone ?? "", enteredCode: otpViewModel.userData?.code ?? 0, code: Int(otpString) ?? 0) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.setRootToHome()
                case .failure(let error):
                    self?.errorLabel.isHidden = false
                    self?.errorLabel.text = error.localizedDescription
                }
                self?.verifyButton.isEnabled = true
            }
        }
    }
    
    private func setRootToHome() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "Home") as! UINavigationController
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
    
    func resend() {
                
        errorLabel.text = ""
        
        viewModel.processLogin(mobileNumber: otpViewModel.userData?.email ?? "") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    print(data)
                   
                case .failure(let error):
                    self?.errorLabel.text = error.localizedDescription
                }
                self?.otpViewModel.restartTimer()
            }
        }
    }
   
    @IBAction func didTapVerifyButton(_ sender: Any) {
        verify()
    }
    
    
    @IBAction func didTapResendButton(_ sender: Any) {
        resend()
    }
    
}

extension OTPViewController: TimerViewModelDelegate {
    func timerDidUpdate(timeString: String) {
        timerLabel.text = timeString
        timerLabel.isHidden = false
    }
    
    func timerDidFinish(Enabled: Bool) {
        resendButton.isEnabled = Enabled
        timerLabel.isHidden = Enabled
    }
}
