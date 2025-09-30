//
//  AddAdoptionViewController.swift
//  Wlif
//
//  Created by OSX on 15/07/2025.
//

import UIKit

class AddAdoptionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var petnameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var ageGroupTextField: UITextField!
    @IBOutlet weak var bloodTypeTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = AddAdoptionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        bind()
        if viewModel.isFromEdit == true {
            viewModel.getAdoptionDetails()
        }
        setupTextView()
        setupHeaderActions()
    }
    
    func setupTextView() {
        descTextView.delegate = self
        descTextView.text = viewModel.placeholder
        descTextView.font = UIFont.systemFont(ofSize: 14)
        descTextView.textColor = UIColor(hex: "8A8A8B")
    }
   
    func setupCollectionView() {
        collectionView.registerCell(cell: AddAdoptionImagesCollectionViewCell.self)
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
        
        viewModel.onAdoptionDetailsFetched = { [weak self] adoption in
            guard let self = self else { return }
            
            petnameTextField.text = adoption?.petName
            descTextView.text = adoption?.description
            locationTextField.text = adoption?.location
            ageGroupTextField.text = adoption?.age
            bloodTypeTextField.text = adoption?.bloodType
            collectionView.reloadData()
        }
        
        viewModel.onImagesDownloaded = { [weak self] images in
             self?.collectionView.reloadData()
        }
    }
    
    func setupHeaderActions() {
        headerView.onCartTap = { [weak self] in
            self?.navigate(to: CartViewController.self, from: "Home", storyboardID: "CartViewController")
        }
        
        headerView.onSideMenuTap = { [weak self] in
            self?.navigate(to: SettingsViewController.self, from: "Profile", storyboardID: "SettingsViewController")
        }
        
        headerView.onHomeTap = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
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
    
    @objc func removeImage(_ sender: UIButton) {
        viewModel.isAddCellAvailable = true
        let indx = viewModel.isAddCellAvailable ? sender.tag : sender.tag - 1
        if viewModel.adoptionImages.count >= indx {
            viewModel.adoptionImages.remove(at: indx)
        }
        collectionView.reloadData()
    }
    
    @IBAction func didTapAddPet(_ sender: Any) {
        viewModel.petName = petnameTextField.text
        viewModel.address = locationTextField.text
        viewModel.ageGroup = ageGroupTextField.text
        viewModel.bloodType = bloodTypeTextField.text
        viewModel.description = descTextView.text
        errorLabel.text = ""
        let (isValid, errorMessage) = viewModel.validateFields()
        
        if isValid {
            viewModel.addOrUpdatePet { [weak self] result in
                switch result {
                case .success(_):
                    self?.navigationController?.popViewController(animated: true)
                    
                case .failure(let error):
                    self?.errorLabel.text = error.localizedDescription
                }
            }
        } else {
            
            errorLabel.text = errorMessage
        }
    }
    
    @IBAction func didTapOpenMap(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        
        if viewModel.isFromEdit {
            if let lat = Float(viewModel.adoptiondetails?.lat ?? ""), let lon = Float(viewModel.adoptiondetails?.lon ?? "") {
                vc.viewModel.lat = lat
                vc.viewModel.lon = lon
                vc.viewModel.address = viewModel.adoptiondetails?.location
            }
        }
        vc.viewModel.completionHandler = { [weak self] in
            guard let self else { return }
            locationTextField.text = LocationUtil.load()?.address
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTabBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddAdoptionViewController: UICollectionViewDataSource ,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.isAddCellAvailable ? (viewModel.adoptionImages.count + 1) : viewModel.adoptionImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAdoptionImagesCollectionViewCell",for: indexPath) as! AddAdoptionImagesCollectionViewCell
        
        let indx = viewModel.isAddCellAvailable ? indexPath.row - 1 : indexPath.row
        if indexPath.row == 0 && viewModel.isAddCellAvailable {
            cell.imageView.image = UIImage()
            cell.removeButton.isHidden = true
        } else {
            cell.imageView.image = viewModel.adoptionImages[indx]
            cell.removeButton.isHidden = false
        }
        
        cell.removeButton.tag = indx
        cell.handleDeleteBtn = { [weak self] in
            self?.removeImage(cell.removeButton)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && viewModel.isAddCellAvailable {
            OpenImagePicker()
        }
    }
}


extension AddAdoptionViewController : UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}

extension AddAdoptionViewController {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.dismiss(animated: true) {
                self.viewModel.adoptionImages.append(image)
                
                if self.viewModel.adoptionImages.count < 5 {
                    self.viewModel.isAddCellAvailable = true
                }else{
                    self.viewModel.isAddCellAvailable = false
                }
                self.collectionView.reloadData()
            }
        }
    }
}

extension AddAdoptionViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == viewModel.placeholder {
            textView.text = ""
            textView.textColor = .black
        }
    }
        
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 500
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = viewModel.placeholder
            textView.textColor =  UIColor(hex: "8A8A8B")
        }
    }
}
