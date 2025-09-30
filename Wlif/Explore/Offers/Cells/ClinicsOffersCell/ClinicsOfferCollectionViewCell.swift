//
//  ClinicsOfferCollectionViewCell.swift
//  Wlif
//
//  Created by OSX on 14/08/2025.
//

import UIKit

class ClinicsOfferCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var disctanceLabel: UILabel!
    @IBOutlet weak var closesAtLabel: UILabel!
    
    var displayAllOffers: Bool = false
    
    var clinic: Clinic? {
        didSet {
            displayAllOffers = false
            setupUI(data: clinic)
        }
    }

    var clinicOffer: StoreOffer? {
        didSet {
            displayAllOffers = true
            setupUI(data: clinicOffer)
        }
    }
    
    private func setupUI(data: Any?) {
        if let data = data as? Clinic {
            animalImageView.setImage(from: data.image)
            nameLabel.text = data.name
            descriptionLabel.text = data.shortDesc
            rateLabel.text = "(\(data.rate ?? 0))"
            disctanceLabel.text = data.distance
            closesAtLabel.text = data.closesAt
        } else if let data = data as? StoreOffer {
            animalImageView.setImage(from: data.image)
            nameLabel.text = data.name
            descriptionLabel.text = data.shortDesc
            rateLabel.text = "(\(data.rate ?? 0))"
            disctanceLabel.text = data.distance
            closesAtLabel.text = data.closesAt
        }
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(cell: ClinicsOffersProductsCollectionViewCell.self)
    }
}

extension ClinicsOfferCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayAllOffers ? clinicOffer?.offers?.count ?? 0 : clinic?.offers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClinicsOffersProductsCollectionViewCell", for: indexPath) as? ClinicsOffersProductsCollectionViewCell else { return UICollectionViewCell()}
        if displayAllOffers {
            if let data = clinicOffer?.offers?[indexPath.row] {
                cell.configure(with: data)
            }
        } else {
            if let data = clinic?.offers?[indexPath.row] {
                cell.configure(with: data)
            }
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
