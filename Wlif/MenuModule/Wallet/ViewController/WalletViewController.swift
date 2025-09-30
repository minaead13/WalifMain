//
//  WalletViewController.swift
//  Wlif
//
//  Created by OSX on 27/08/2025.
//

import UIKit

class WalletViewController: UIViewController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = WalletViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setTableView()
        bind()
        viewModel.getWallet()
        setupHeaderActions()
    }
    
    func bind() {
        viewModel.onWalletFetched = { [weak self] wallet in
            self?.balanceLabel.text = wallet?.balance
            self?.tableView.reloadData()
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
    
    func setTableView() {
        tableView.registerCell(cell: WalletTableViewCell.self)
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
    
    @IBAction func didTabBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTapChargeBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChargeWalletViewController") as! ChargeWalletViewController
        vc.viewModel.balanceAdded = { [weak self] in
            self?.viewModel.getWallet()
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.wallet?.transactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTableViewCell", for: indexPath) as? WalletTableViewCell else { return UITableViewCell() }
        
        if let data = viewModel.wallet?.transactions?[indexPath.row] {
            cell.configure(data: data)
        }
        return cell
    }
}
