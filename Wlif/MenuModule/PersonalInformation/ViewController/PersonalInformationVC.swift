//
//  PersonalInformationVC.swift
//  Wlif
//
//  Created by OSX on 06/08/2025.
//

import UIKit

class PersonalInformationVC: UIViewController {

    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var headerView: HeaderView!
    
    private lazy var validator = LoginValidator()
    private lazy var viewModel = PersonalInformationViewModel(validator: validator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        bind()
        viewModel.getUserDetails()
        setupHeaderActions()
        setupHeaderActions()
    }
    
    func bind() {
        viewModel.onUserDetailsFetched = { [weak self] userModel in
            guard let self else { return }
            personImageView.setImage(from: userModel?.user?.image)
            fullnameTextField.text = userModel?.user?.name
          //  phoneTextField.text = user?.phone
            emailTextField.text = userModel?.user?.email
        }
        
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
    
    private func OpenImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        let camera = UIAlertAction(title: "Camera".locale, style: .default) { (action) in
            imagePicker.sourceType = .camera
            self.present(imagePicker,animated: true,completion: nil)
        }
        
        let library = UIAlertAction(title: "Photos".locale, style: .default) { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker,animated: true,completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel".locale, style: .cancel) { (action) in
        }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupHeaderActions() {
        headerView.onCartTap = { [weak self] in
            self?.navigate(to: CartViewController.self, from: "Home", storyboardID: "CartViewController")
        }
        
        headerView.onSideMenuTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        headerView.onHomeTap = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSelectImage(_ sender: Any) {
        OpenImagePicker()
    }
    
    @IBAction func didTapSaveBtn(_ sender: Any) {
        viewModel.editProfile(name: self.fullnameTextField.text ?? "", email: self.emailTextField.text ?? "")
    }
}

extension PersonalInformationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.dismiss(animated: true) {
                self.viewModel.userImage?.append(image)
                DispatchQueue.main.async { [weak self] in
                    self?.personImageView.image = image
                }
            }
        }
    }
}
