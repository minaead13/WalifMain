//
//  HotelRoomTableViewCell.swift
//  Wlif
//
//  Created by OSX on 30/07/2025.
//

import UIKit

class HotelRoomTableViewCell: UITableViewCell {

    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var noOfAnimalsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var servicesCollectionViewHeightConstraint: NSLayoutConstraint!
    
    var services: [Service] = [] {
        didSet {
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            let lineSpacing = layout?.minimumLineSpacing ?? 8
            let sectionInsets = layout?.sectionInset ?? .zero
            let rowHeight: CGFloat = 16

            let serviceCount = services.count
    
            let numberOfRows = ceil(CGFloat(serviceCount) / 1)

            let totalHeight =
                (numberOfRows * rowHeight) +
                ((numberOfRows - 1) * lineSpacing) +
                sectionInsets.top + sectionInsets.bottom

            servicesCollectionViewHeightConstraint.constant = totalHeight
            collectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    func configure(data: RoomModel) {
        hotelNameLabel.text = data.name
        noOfAnimalsLabel.text = "\(data.animalsNumber ?? 0)"
        priceLabel.text = "\(data.price ?? 0)"
    }
    
    func configure(data: OfferHotelDetailsModel) {
        hotelNameLabel.text = data.name
        noOfAnimalsLabel.text = "\(data.animalsNumber ?? 0)"
        priceLabel.text = "\(data.price ?? 0) SR - Of Day"
    }
    
    func setupCollectionView() {
        collectionView.registerCell(cell: AvailableServiceCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
     }
}

extension HotelRoomTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailableServiceCollectionViewCell", for: indexPath) as? AvailableServiceCollectionViewCell else { return UICollectionViewCell() }
        cell.serviceLabel.text = services[indexPath.row].name
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 16)
    }
    
}
