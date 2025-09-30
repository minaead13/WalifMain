//
//  OrderInfoTableViewCell.swift
//  Wlif
//
//  Created by OSX on 03/09/2025.
//

import UIKit

class OrderInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var serviceTypeOrStartDateLabel: UILabel!
    @IBOutlet weak var serviceOrEndDateLabel: UILabel!
    @IBOutlet weak var serviceTimeOrNumberOfAnimalsLabel: UILabel!
    @IBOutlet weak var numberOfRoomsLabel: UILabel!
    
    @IBOutlet weak var serviceTypeOrStartDateTitleLabel: UILabel!
    @IBOutlet weak var serviceOrEndDateTitleLabel: UILabel!
    @IBOutlet weak var serviceTimeOrNumberOfAnimalsTitleLabel: UILabel!
    
    @IBOutlet weak var roomsStack: UIStackView!
    
    @IBOutlet weak var titleOfCollectionView: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var slogan: Services?
    
    var animalTypes: [AnimalType] = [] {
        didSet {
            switch slogan {
            case .veterinaryServices:
                updateHeightForVeterinaryServices()
            default:
                updateHeightForOtherServices()
            }
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
        collectionView.registerCell(cell: AvailableServiceCollectionViewCell.self)
    }
    
    func configure(data: OrderDetailsModel) {
        let isVeterinary = slogan == .veterinaryServices
        
        // Order Info
        orderIdLabel.text = "#\(data.orderNumber ?? "")"
        orderStatusLabel.text = "\(data.status ?? "")"
        
        // Conditional Values
        serviceTypeOrStartDateLabel.text = isVeterinary ? "\(data.serviceType ?? "")" : "\(data.startDate ?? "")"
        serviceOrEndDateLabel.text = isVeterinary ? "\(data.serviceDate ?? "")" : "\(data.endDate ?? "")"
        serviceTimeOrNumberOfAnimalsLabel.text = isVeterinary ? data.serviceTime?.to12HourTime() : "\(data.animalsNumber ?? 0)"
        
        // Rooms Handling
        roomsStack.isHidden = slogan == .veterinaryServices
        numberOfRoomsLabel.text = "\(data.roomsNumber ?? 0)"
        
        // Titles with Localization
        serviceTypeOrStartDateTitleLabel.text = isVeterinary ?  "Service Type :".localized : "Start Date :".localized
        serviceOrEndDateTitleLabel.text = isVeterinary ?  "Service Date :".localized : "End Date :".localized
        serviceTimeOrNumberOfAnimalsTitleLabel.text = isVeterinary ?  "Service Time :".localized : "Number of Animals :".localized
        titleOfCollectionView.text = isVeterinary ?  "Animal Type :".localized : "Services :".localized
    }
    
    private func updateHeightForVeterinaryServices() {
        let itemsPerRow = 3
        let rowHeight = 45
        let numberOfRows = Int(ceil(Double(animalTypes.count) / Double(itemsPerRow)))
        collectionViewHeightConstraint.constant = CGFloat(numberOfRows * rowHeight)
    }
    
    private func updateHeightForOtherServices() {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let lineSpacing = layout?.minimumLineSpacing ?? 8
        let sectionInsets = layout?.sectionInset ?? .zero
        let rowHeight: CGFloat = 18
        
        let serviceCount = animalTypes.count
        let itemsPerRow: CGFloat = 2
        let numberOfRows = ceil(CGFloat(serviceCount) / itemsPerRow)
        
        let totalHeight =
        (numberOfRows * rowHeight) +
        ((numberOfRows - 1) * lineSpacing) +
        sectionInsets.top + sectionInsets.bottom
        
        collectionViewHeightConstraint.constant = totalHeight
    }
}

extension OrderInfoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animalTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch slogan {
        case .veterinaryServices:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VetAppointmentCollectionViewCell", for: indexPath) as? VetAppointmentCollectionViewCell else { return UICollectionViewCell()}
            
            cell.nameLabel.text = animalTypes[indexPath.row].name
            cell.setColor(isSelected: true)
            
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailableServiceCollectionViewCell", for: indexPath) as? AvailableServiceCollectionViewCell else { return UICollectionViewCell() }
            cell.serviceLabel.text = animalTypes[indexPath.row].name
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch slogan {
        case .veterinaryServices:
            let numberOfItemsPerRow: CGFloat = 3
            let spacing: CGFloat = 16

            let totalSpacing = (numberOfItemsPerRow - 1) * spacing

            let width = (collectionView.frame.width - totalSpacing) / numberOfItemsPerRow
            
            return CGSize(width: width, height: 40)
            
        default:
            let totalSpacing: CGFloat = 16
            let numberOfItemsPerRow: CGFloat = 2
            let width = (collectionView.frame.width - totalSpacing) / numberOfItemsPerRow

            return CGSize(width: width, height: 18)
        }
    }
}
