//
//  LanguagesViewController.swift
//  Wlif
//
//  Created by OSX on 11/08/2025.
//

import UIKit

class LanguagesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    
    let viewModel = LanguagesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        setupHeaderActions()
    }
    
    func setupTableView() {
        tableView.registerCell(cell: LanguageTableViewCell.self)
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
    
    @IBAction func didTapSaveBtn(_ sender: Any) {
        let currentLang = LanguageManager.shared.currentLanguage
        let newLang: Languages = (viewModel.selectedIndex == 0) ? .arSa : .en
        
        if currentLang == newLang {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        LanguageManager.shared.setLanguage(language: newLang)
        
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate {
            sceneDelegate.rootViewController()
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LanguagesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell", for: indexPath) as? LanguageTableViewCell else { return UITableViewCell() }
        
        cell.languageLabel.text = viewModel.languages[indexPath.row]
        let isSelected = indexPath.row == viewModel.selectedIndex
        cell.selectImageView.image = UIImage(named: isSelected ? "selected" : "unselected")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndex = indexPath.row
        tableView.reloadData()
    }
}
