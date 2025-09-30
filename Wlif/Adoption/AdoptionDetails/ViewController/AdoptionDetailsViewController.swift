//
//  AdoptionDetailsViewController.swift
//  Wlif
//
//  Created by OSX on 13/07/2025.
//

import UIKit

class AdoptionDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backTitleLabel: UILabel!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = AdoptionDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind()
        viewModel.getAdoptionDetails()
        setupHeaderActions()
    }
    
    func setupTableView() {
        tableView.registerCell(cell: AdoptionDetailsTableViewCell.self)
        tableView.registerCell(cell: CommentsTableViewCell.self)
    }
    
    func bind() {
        viewModel.onAdoptionDetailsFetched = { [weak self] details in
            DispatchQueue.main.async {
                self?.backTitleLabel.text = "\("Details".localized) >\(self?.viewModel.adoptiondetails?.petName ?? "")"
                self?.tableView.reloadData()
            }
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
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AdoptionDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return 1
            
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdoptionDetailsTableViewCell", for: indexPath) as? AdoptionDetailsTableViewCell else { return UITableViewCell() }
            
            if let data = viewModel.adoptiondetails {
                cell.configure(data: data)
            }
            
            cell.handleLikeSelection = { [weak self] in
                guard let self else { return }
                viewModel.deleteFavPets(id: viewModel.adoptiondetails?.id ?? 0)
            }
            
            cell.handleSelection = { [weak self] in
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "CommunicationViewController") as! CommunicationViewController
                vc.modalPresentationStyle = .overFullScreen
                vc.viewModel.phoneNumber = self?.viewModel.adoptiondetails?.phone ?? ""
                self?.present(vc, animated: true)
            }
            
            cell.selectionStyle = .none
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
            let comments = viewModel.adoptiondetails?.comments ?? []
            cell.comments = comments
            
            cell.handleSendAction = { [weak self] text, isReply, parentId in
                guard let self else { return }
                viewModel.addComment(comment: text, isReply: isReply, parentId: parentId) { _ in
                    cell.commentTextField.text = ""
                    cell.isReply = false
                }
            }
            cell.selectionStyle = .none
            return cell
        
        default:
            return UITableViewCell()
        }
    }
}
