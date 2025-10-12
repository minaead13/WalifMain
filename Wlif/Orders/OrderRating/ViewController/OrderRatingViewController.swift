//
//  OrderRatingViewController.swift
//  Wlif
//
//  Created by Mina Lamey on 09/10/2025.
//

import UIKit
import Cosmos

class OrderRatingViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingTextView: UITextView!
    
    // MARK: - Properties
    var viewModel = OrderRatingViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupTextView()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
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
    
    //MARK: - Setup TextView
    func setupTextView() {
        ratingTextView.delegate = self
        ratingTextView.text = viewModel.placeholder
        ratingTextView.font = UIFont.systemFont(ofSize: 14)
        ratingTextView.textColor = UIColor(hex: "787878")
    }
    
    // MARK: - Actions
    @IBAction func didTapSendButton(_ sender: Any) {
        let rating = ratingView.rating
        if rating != 0 {
            viewModel.rate = Int(rating)
            viewModel.comment = ratingTextView.text ?? ""
            viewModel.addRateOrder { [weak self] result in
                switch result {
                case .success:
                    self?.viewModel.completionHandler?()
                    self?.dismiss(animated: true)
                case .failure(let error):
                    print("error is \(error)")
                }
            }
        }
    }
    
    
    @IBAction func didTapDismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension OrderRatingViewController: UITextViewDelegate {
    
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
