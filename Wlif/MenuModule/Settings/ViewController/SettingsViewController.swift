//
//  SettingsViewController.swift
//  Wlif
//
//  Created by OSX on 05/08/2025.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
    }
    
    func setupTableView() {
        tableView.registerCell(cell: SettingsTableViewCell.self)
        tableView.registerCell(cell: SettingsHeaderTableViewCell.self)
    }
    
    @IBAction func didTapHomeBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}



extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return viewModel.settingsArray.count

        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsHeaderTableViewCell", for: indexPath) as? SettingsHeaderTableViewCell else { return UITableViewCell() }
            
            cell.handleProfileSelection = { [weak self] in
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.handleFavSelection = { [weak self] in
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
            
            cell.settinsImageView.image = UIImage(named: viewModel.settingsArray[indexPath.row].image ?? "")
            cell.nameLabel.text = viewModel.settingsArray[indexPath.row].name
            cell.lineView.isHidden = indexPath.row == viewModel.settingsArray.count - 1 ? true : false
            cell.selectionStyle = .none
            return cell

        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let storyboard = UIStoryboard(name: "Orders", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "OrderHistoryViewController") as! OrderHistoryViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 3:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LanguagesViewController") as! LanguagesViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 4:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 7:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            default:
                break
            }
        }
    }
    
}
