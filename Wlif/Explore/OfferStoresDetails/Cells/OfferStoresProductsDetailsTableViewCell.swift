//
//  OfferStoresProductsDetailsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 17/08/2025.
//

import UIKit

class OfferStoresProductsDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    
    var offers: [OfferStoresDetailsModel] = [] {
        didSet {
            heightContraint.constant = CGFloat(111 * (offers.count))
            tableView.reloadData()
        }
    }
    
    var updateQnty: ((Int)-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cell: OfferStoresProductDetailTableViewCell.self)
    }
    
}

extension OfferStoresProductsDetailsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OfferStoresProductDetailTableViewCell", for: indexPath) as? OfferStoresProductDetailTableViewCell else { return UITableViewCell() }
        cell.configure(data: offers[indexPath.row])
        cell.updateQnty = { [weak self] in
            guard let self else { return }
            updateQnty?(offers[indexPath.row].id ?? 0)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 111
    }
}
