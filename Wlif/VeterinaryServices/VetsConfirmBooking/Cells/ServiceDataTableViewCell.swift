//
//  ServiceDataTableViewCell.swift
//  Wlif
//
//  Created by OSX on 23/07/2025.
//

import UIKit

class ServiceDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var serviceTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var animalTypes: [AnimalType] = [] {
        didSet {
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
        
        collectionView.registerCell(cell: VetAppointmentCollectionViewCell.self)
    }
    
}

extension ServiceDataTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animalTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VetAppointmentCollectionViewCell", for: indexPath) as? VetAppointmentCollectionViewCell else { return UICollectionViewCell()}
        
        cell.nameLabel.text = animalTypes[indexPath.row].name
        cell.setColor(isSelected: true)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 82, height: 30)
    }
}
