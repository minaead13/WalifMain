//
//  AddoptionOffersTableViewCell.swift
//  Wlif
//
//  Created by OSX on 24/08/2025.
//

import UIKit

class AddoptionOffersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableViewConstant: NSLayoutConstraint!
    
    var adoptionOffers: [AdoptionOffer] = [] {
        didSet {
            heightTableViewConstant.constant = CGFloat(adoptionOffers.count * 50)
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cell: AddoptionOfferTableViewCell.self)
    }
}

extension AddoptionOffersTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adoptionOffers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddoptionOfferTableViewCell", for: indexPath) as? AddoptionOfferTableViewCell else { return UITableViewCell() }
        
        cell.configure(adoptionOffers: adoptionOffers[indexPath.row])
        
        cell.selectionStyle = .none
        return cell
    }
}
