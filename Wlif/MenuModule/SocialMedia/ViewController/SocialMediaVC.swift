//
//  SocialMediaVC.swift
//  Wlif
//
//  Created by OSX on 07/08/2025.
//

import UIKit

class SocialMediaVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = SocialMediaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        bind()
        setupTableView()
        viewModel.getSocialMedia()
    }
    
    func bind() {
        viewModel.onSocialMediaFetched = { [weak self] socialMedia in
            guard let self else { return }
            tableView.reloadData()
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
    
    func setupTableView() {
        tableView.registerCell(cell: SettingsTableViewCell.self)
    }
    
    
    @IBAction func didTapDismissBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension SocialMediaVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.socialMedia?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
        
        cell.settinsImageView.setImage(from: viewModel.socialMedia?[indexPath.row].icon)
        cell.nameLabel.text = viewModel.socialMedia?[indexPath.row].title
        cell.lineView.isHidden = indexPath.row == (viewModel.socialMedia?.count ?? 0) - 1 ? true : false
        cell.backgroundImageView.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: viewModel.socialMedia?[indexPath.row].url ?? "") {
            UIApplication.shared.open(url)
        }
    } 
}
