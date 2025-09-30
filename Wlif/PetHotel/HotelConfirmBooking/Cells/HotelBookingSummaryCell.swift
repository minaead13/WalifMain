//
//  HotelBookingSummaryCell.swift
//  Wlif
//
//  Created by OSX on 31/07/2025.
//

import UIKit

class HotelBookingSummaryCell: UITableViewCell {
    
    @IBOutlet weak var entryDateLabel: UILabel!
    @IBOutlet weak var exitDateLabel: UILabel!
    @IBOutlet weak var noOfAnimalsLabel: UILabel!
    @IBOutlet weak var noOfRoomsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewViewHeightConstraint: NSLayoutConstraint!
    
    var services: [Service]? {
        didSet {
            tableViewViewHeightConstraint.constant = CGFloat(47 * (services?.count ?? 0))
            self.tableView.reloadData()
        }
    }
    
    var servicesSelectedIndexes: [Int] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cell: HotelBookingServiceSelectionTableViewCell.self)
    }
}

extension HotelBookingSummaryCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingServiceSelectionTableViewCell", for: indexPath) as? HotelBookingServiceSelectionTableViewCell else { return UITableViewCell()
        }
        
        
        cell.selectionImageView.image = UIImage(named: "selected")
        cell.priceLabel.text = "\(self.services?[indexPath.row].price ?? 0) \("SR".localized)"
        cell.nameLabel.text = self.services?[indexPath.row].name
        
        cell.selectionStyle = .none
        return cell
    }
    
  
}
