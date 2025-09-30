//
//  AddressesViewController.swift
//  Wlif
//
//  Created by OSX on 11/08/2025.
//

import UIKit

class AddressesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = AddressesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getaddresses()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        bind()
        setupHeaderActions()
    }
    
    func setupTableView() {
        tableView.registerCell(cell: AddressTableViewCell.self)
    }
    
    func bind() {
        viewModel.onaddressesListFetched = { [weak self] favs in
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
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddressesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.addresses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as? AddressTableViewCell else { return UITableViewCell() }
        
        if let data = viewModel.addresses?[indexPath.row] {
            cell.configure(with: data)
        }
        
        cell.handleSelection = { [weak self] in
            guard let self else { return }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController
            vc.viewModel.isDeleteAddress = true
            vc.viewModel.completionHandler = { [weak self] in
                guard let self else { return }
                viewModel.deleteAddress(id: viewModel.addresses?[indexPath.row].id ?? 0)
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Adoption", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        
        if let lat = Float(viewModel.addresses?[indexPath.row].lat ?? ""), let lon = Float(viewModel.addresses?[indexPath.row].lon ?? "") {
            vc.viewModel.lat = lat
            vc.viewModel.lon = lon
            vc.viewModel.addressType = "\(viewModel.addresses?[indexPath.row].addressType ?? 0)"
            vc.viewModel.address = viewModel.addresses?[indexPath.row].address
        }
        
        vc.viewModel.completionHandler = { [weak self] in
            guard let self else { return }
            viewModel.getaddresses()
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


