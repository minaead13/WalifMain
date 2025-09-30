//
//  StoreOfferDetailsCollectionViewCell.swift
//  Wlif
//
//  Created by OSX on 13/08/2025.
//

import UIKit

class StoreOfferDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var disctanceLabel: UILabel!
    @IBOutlet weak var closesAtLabel: UILabel!
    
    
    var store: StoreOffer? {
        didSet {
            guard let store = store else { return }
            animalImageView.setImage(from: store.image)
            nameLabel.text = store.name
            descriptionLabel.text = store.shortDesc
            deliveryLabel.text = store.delivery
            rateLabel.text = "(\(store.rate ?? 0))"
            disctanceLabel.text = store.distance
            closesAtLabel.text = store.closesAt
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(cell: StoreOfferProductsCollectionViewCell.self)
    }
}

extension StoreOfferDetailsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store?.offers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreOfferProductsCollectionViewCell", for: indexPath) as? StoreOfferProductsCollectionViewCell else { return UICollectionViewCell()}
        if let data = store?.offers?[indexPath.row] {
            cell.configure(with: data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item is \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: 103, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
