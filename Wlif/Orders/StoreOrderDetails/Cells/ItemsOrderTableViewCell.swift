//
//  ItemsOrderTableViewCell.swift
//  Wlif
//
//  Created by OSX on 03/09/2025.
//

import UIKit

class ItemsOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var merchantImageView: UIImageView!
    @IBOutlet weak var merchantNameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewConstantHeight: NSLayoutConstraint!
    
    var order: StoreOrderModel? {
        didSet {
            merchantImageView.setImage(from: order?.merchantImage)
            merchantNameLabel.text = order?.merchantName
         //   rateLabel.text = "\(order?.rate ?? 0)"
            tableViewConstantHeight.constant = CGFloat((order?.items?.count ?? 0) * 44)
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
        tableView.registerCell(cell: ItemOrderTableViewCell.self)
    }
}

extension ItemsOrderTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemOrderTableViewCell", for: indexPath) as? ItemOrderTableViewCell else { return UITableViewCell() }
        
        let data = order?.items?[indexPath.row]
        cell.nameLabel.text = data?.name
        cell.sizeLabel.text = data?.size
        cell.priceLabel.text = "\(data?.price ?? 0)"
        cell.itemImageView.setImage(from: data?.image)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
