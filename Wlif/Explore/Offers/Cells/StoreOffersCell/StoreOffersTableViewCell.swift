//
//  StoreOffersTableViewCell.swift
//  Wlif
//
//  Created by OSX on 13/08/2025.
//

import UIKit

class StoreOffersTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var seeAllView: UIView!
    
    var stores: [StoreOffer] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var handleSelection: (() -> Void)?
    var didSelectItem : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(cell: StoreOfferDetailsCollectionViewCell.self)
    }
    
    @IBAction func didTapSeeAllBtn(_ sender: Any) {
        handleSelection?()
    }
    
    
}

extension StoreOffersTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stores.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreOfferDetailsCollectionViewCell", for: indexPath) as? StoreOfferDetailsCollectionViewCell else { return UICollectionViewCell()}
        cell.store = stores[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem?()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 342, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
