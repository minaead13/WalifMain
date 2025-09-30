//
//  ProfileVC.swift
//  Wlif
//
//  Created by OSX on 07/08/2025.
//

import UIKit

class ProfileVC: UIViewController {

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
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}



extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return viewModel.profileArray.count

        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsHeaderTableViewCell", for: indexPath) as? SettingsHeaderTableViewCell else { return UITableViewCell() }
            
            cell.handleProfileSelection = { [weak self] in
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "PersonalInformationVC") as! PersonalInformationVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.actionsView.isHidden = true

            cell.selectionStyle = .none
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
            
            cell.settinsImageView.image = UIImage(named: viewModel.profileArray[indexPath.row].image ?? "")
            cell.nameLabel.text = viewModel.profileArray[indexPath.row].name
            cell.lineView.isHidden = indexPath.row == viewModel.profileArray.count - 1 ? true : false
            if indexPath.row == 2 || indexPath.row == 3 {
                cell.backgroundImageView.backgroundColor = .white
                cell.nameLabel.textColor = UIColor(hex: "C10D26")
            } else {
                cell.backgroundImageView.backgroundColor = UIColor(hex: "DFFF32")
                cell.nameLabel.textColor = .label
            }


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
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PersonalInformationVC") as! PersonalInformationVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 1:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddressesViewController") as! AddressesViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 2:
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
                
            default:
                break
            }
        }
    }
    
}
