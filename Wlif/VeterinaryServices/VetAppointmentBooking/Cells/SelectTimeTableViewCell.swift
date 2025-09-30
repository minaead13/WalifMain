//
//  SelectTimeTableViewCell.swift
//  Wlif
//
//  Created by OSX on 21/07/2025.
//

import UIKit

class SelectTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var handleSelection: ((_ selectedType: TimeSlot) -> Void)?
    var timeSelectedIndex: Int?
    
    var timeSlots: [TimeSlot] = [] {
        didSet {
            let itemsPerRow = 3
            let rowHeight = 45
            let numberOfRows = Int(ceil(Double(timeSlots.count) / Double(itemsPerRow)))
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

extension SelectTimeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeSlots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VetAppointmentCollectionViewCell", for: indexPath) as? VetAppointmentCollectionViewCell else { return UICollectionViewCell()}
        
        cell.nameLabel.text = timeSlots[indexPath.row].time
        let isSelected = indexPath.row == timeSelectedIndex
        cell.setColor(isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleSelection?(timeSlots[indexPath.row])
        timeSelectedIndex = indexPath.row
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
