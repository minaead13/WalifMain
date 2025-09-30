//
//  PetStoreLocationAndProductsCell.swift
//  Wlif
//
//  Created by OSX on 03/08/2025.
//

import UIKit

class PetStoreLocationAndProductsCell: UITableViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var handleLocationSelection: (() -> Void)?
    
    var items: [Item] = [] {
        didSet {
            let height = CGFloat(82 * items.count)
            tableViewHeightConstraint.constant = height
            self.tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
        setLocation()
    }
    
    func setLocation() {
        if LocationUtil.load() != nil {
            locationLabel.text = LocationUtil.load()?.address
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cell: ProductOrderTableViewCell.self)
    }

    
    @IBAction func didTapLocationBtn(_ sender: Any) {
        handleLocationSelection?()
    }
}


extension PetStoreLocationAndProductsCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductOrderTableViewCell") as? ProductOrderTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(item: items[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
}
