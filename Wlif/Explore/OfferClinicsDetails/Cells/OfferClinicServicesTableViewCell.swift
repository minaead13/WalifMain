//
//  OfferClinicServicesTableViewCell.swift
//  Wlif
//
//  Created by OSX on 18/08/2025.
//

import UIKit

class OfferClinicServicesTableViewCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    
    var offers: [OfferVeterinaryServicesDetailsModel] = [] {
        didSet {
            heightContraint.constant = CGFloat(107 * (offers.count))
            tableView.reloadData()
        }
    }
    
    var didSelect: ((OfferVeterinaryServicesDetailsModel)-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cell: ServiceDetailsTableViewCell.self)
    }
    
}

extension OfferClinicServicesTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceDetailsTableViewCell", for: indexPath) as? ServiceDetailsTableViewCell else { return UITableViewCell() }
        cell.configure(data: offers[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect?(offers[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
}
