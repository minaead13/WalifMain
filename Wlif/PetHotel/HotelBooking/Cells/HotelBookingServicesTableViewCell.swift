//
//  HotelBookingServicesTableViewCell.swift
//  Wlif
//
//  Created by OSX on 29/07/2025.
//

import UIKit

class HotelBookingServicesTableViewCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewViewHeightConstraint: NSLayoutConstraint!
    
    var selectedServices: [Service] = []
    var didUpdateSelection: (([Service]) -> Void)?
    var services: [Service] = [] {
        didSet {
            tableViewViewHeightConstraint.constant = CGFloat(47 * (services.count))
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

extension HotelBookingServicesTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingServiceSelectionTableViewCell", for: indexPath) as? HotelBookingServiceSelectionTableViewCell else { return UITableViewCell()
        }
        
        let isSelected = servicesSelectedIndexes.contains(indexPath.row)
        cell.selectionImageView.image = UIImage(named: isSelected ? "selected" : "unselected")
        cell.priceLabel.text = "\(self.services[indexPath.row].price ?? 0)"
        cell.nameLabel.text = self.services[indexPath.row].name
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if servicesSelectedIndexes.contains(indexPath.row) {
            servicesSelectedIndexes.removeAll { $0 == indexPath.row }
        } else {
            servicesSelectedIndexes.append(indexPath.row)
        }
        
        let selectedService = services[indexPath.row]
        
        if let index = selectedServices.firstIndex(where: { $0.id == selectedService.id }) {
            selectedServices.remove(at: index)
        } else {
            selectedServices.append(selectedService)
        }
        
        didUpdateSelection?(selectedServices)
        
        tableView.reloadData()
    }
}
