//
//  AnimalTypeTableViewCell.swift
//  Wlif
//
//  Created by OSX on 21/07/2025.
//

import UIKit

class AnimalTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var animalTypeSelectedIndexes: [Int] = []
    var selectedAnimalTypes: [AnimalType] = []
    var didUpdateSelection: (([AnimalType]) -> Void)?
    
    var animalTypes: [AnimalType] = [] {
        didSet {
            let itemsPerRow = 3
            let rowHeight = 45
            let numberOfRows = Int(ceil(Double(animalTypes.count) / Double(itemsPerRow)))
            collectionViewHeightConstraint.constant = CGFloat(numberOfRows * rowHeight)
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

extension AnimalTypeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animalTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VetAppointmentCollectionViewCell", for: indexPath) as? VetAppointmentCollectionViewCell else { return UICollectionViewCell()}
        
        cell.nameLabel.text = animalTypes[indexPath.row].name
        let isSelected = animalTypeSelectedIndexes.contains(indexPath.row)
        cell.setColor(isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if animalTypeSelectedIndexes.contains(indexPath.row) {
            animalTypeSelectedIndexes.removeAll { $0 == indexPath.row }
        } else {
            animalTypeSelectedIndexes.append(indexPath.row)
        }
        
        
        let selectedAnimal = animalTypes[indexPath.row]
        
        if let index = selectedAnimalTypes.firstIndex(where: { $0.id == selectedAnimal.id }) {
            selectedAnimalTypes.remove(at: index)
        } else {
            selectedAnimalTypes.append(selectedAnimal)
        }
        
        didUpdateSelection?(selectedAnimalTypes)
        
        collectionView.reloadData()
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow: CGFloat = 3
        let spacing: CGFloat = 16

        let totalSpacing = (numberOfItemsPerRow - 1) * spacing

        let width = (collectionView.frame.width - totalSpacing) / numberOfItemsPerRow
        
        return CGSize(width: width, height: 40)
    }
}
