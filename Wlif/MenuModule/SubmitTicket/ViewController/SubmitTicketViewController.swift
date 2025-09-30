//
//  SubmitTicketViewController.swift
//  Wlif
//
//  Created by OSX on 10/08/2025.
//

import UIKit

class SubmitTicketViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var errorLabel: UILabel!
    
    let viewModel = SubmitTicketViewModel()
    let commentPlaceholder = "Comment".localized
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        bind()
        setupCommentPlaceholder()
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
    
    private func setupCommentPlaceholder() {
        commentTextView.delegate = self
        commentTextView.text = commentPlaceholder
        commentTextView.textColor = UIColor(hex: "787878")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == commentPlaceholder {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = commentPlaceholder
            textView.textColor = UIColor(hex: "787878")
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTapSendBtn(_ sender: Any) {
        if let name = fullnameTextField.text, !name.isEmpty,
           let email = emailTextField.text, !email.isEmpty,
           let comment = commentTextView.text, !comment.isEmpty {
            viewModel.submitTicket(name: name, email: email, comment: comment) { [weak self] result in
                switch result {
                case .success(_):
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ConfirmTicketViewController") as! ConfirmTicketViewController
                    self?.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    self?.errorLabel.text = error.localizedDescription
                }
            }
        }
    }
}
