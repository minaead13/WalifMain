//
//  ClinicsOffersTableViewCell.swift
//  Wlif
//
//  Created by OSX on 14/08/2025.
//

import UIKit

class ClinicsOffersTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var clinics: [Clinic] = [] {
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
        collectionView.registerCell(cell: ClinicsOfferCollectionViewCell.self)
    }

   
    
    @IBAction func didTapSeeAllBtn(_ sender: Any) {
        handleSelection?()
    }
   
    
}

extension ClinicsOffersTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clinics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClinicsOfferCollectionViewCell", for: indexPath) as? ClinicsOfferCollectionViewCell else { return UICollectionViewCell()}
        cell.clinic = clinics[indexPath.row]
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
