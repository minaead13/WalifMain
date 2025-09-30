//
//  HotelDetailsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 28/07/2025.
//

import UIKit

class HotelDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var closesAtLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var hotelCollectionView: UICollectionView!
    @IBOutlet weak var stepsCollectionView: UICollectionView!
    @IBOutlet weak var stepsWidthConst: NSLayoutConstraint!
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    @IBOutlet weak var servicesCollectionViewHeightConstraint: NSLayoutConstraint!
    
    var hotelDetails: HotelDetailsModel? {
        didSet {
            
            let layout = servicesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
            let lineSpacing = layout?.minimumLineSpacing ?? 8
            let sectionInsets = layout?.sectionInset ?? .zero
            let rowHeight: CGFloat = 18

            let serviceCount = hotelDetails?.services?.count ?? 0
            let itemsPerRow: CGFloat = 2
            let numberOfRows = ceil(CGFloat(serviceCount) / itemsPerRow)

            let totalHeight =
                (numberOfRows * rowHeight) +
                ((numberOfRows - 1) * lineSpacing) +
                sectionInsets.top + sectionInsets.bottom

            servicesCollectionViewHeightConstraint.constant = totalHeight
            servicesCollectionView.reloadData()
            
            
            hotelCollectionView.reloadData()
            stepsWidthConst.constant = CGFloat((14 * (hotelDetails?.store?.attachments?.count ?? 0)) + 14)
            stepsCollectionView.reloadData()
            
            if let data = hotelDetails?.store {
                configure(data: data)
            }
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: 0, section: 0)
                let scrollPosition: UICollectionView.ScrollPosition = LanguageManager.shared.isRightToLeft ? .right : .left
                
                if self.stepsCollectionView.numberOfItems(inSection: 0) > 0 {
                    self.stepsCollectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
                }
                
                if self.hotelCollectionView.numberOfItems(inSection: 0) > 0 {
                    self.hotelCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
                }
            }

        }
    }
    
    var currentIndx: Int = 0 {
        didSet {
            stepsCollectionView.reloadData()
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func configure(data: PetHotel) {
        hotelNameLabel.text = data.name
        descLabel.text = data.shortDesc
        locationLabel.text = data.location
        distanceLabel.text = data.distance
        closesAtLabel.text = data.closesAt
        rateLabel.text = "\(data.rate ?? 0)"
    }

   func setupCollectionView() {
       hotelCollectionView.registerCell(cell: PetsCollectionViewCell.self)
       hotelCollectionView.delegate = self
       hotelCollectionView.dataSource = self
       
       stepsCollectionView.registerCell(cell: StepCell.self)
       stepsCollectionView.delegate = self
       stepsCollectionView.dataSource = self
       
       servicesCollectionView.registerCell(cell: AvailableServiceCollectionViewCell.self)
       servicesCollectionView.delegate = self
       servicesCollectionView.dataSource = self
    }
}

extension HotelDetailsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case hotelCollectionView, stepsCollectionView:
            return hotelDetails?.store?.attachments?.count ?? 0
            
        case servicesCollectionView:
            return hotelDetails?.services?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hotelCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetsCollectionViewCell", for: indexPath) as? PetsCollectionViewCell else { return UICollectionViewCell() }
            cell.petsImageView.setImage(from: hotelDetails?.store?.attachments?[indexPath.row].image)
            return cell
            
        } else if collectionView == stepsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StepCell", for: indexPath) as? StepCell else { return UICollectionViewCell() }
            
            cell.backView.backgroundColor = UIColor(hex: "E9E9E9")
            
            if indexPath.row == currentIndx {
                cell.backView.backgroundColor = .label
            } else {
                cell.backView.backgroundColor = UIColor(hex: "E9E9E9")
            }
            
            return cell
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailableServiceCollectionViewCell", for: indexPath) as? AvailableServiceCollectionViewCell else { return UICollectionViewCell() }
            cell.serviceLabel.text = hotelDetails?.services?[indexPath.row].name
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: 0, height: 0)
        
        if collectionView == hotelCollectionView {
            size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else if collectionView == stepsCollectionView {
            size = CGSize(width: 12, height: 4)
        } else {
            let totalSpacing: CGFloat = 16
            let numberOfItemsPerRow: CGFloat = 2
            let width = (collectionView.frame.width - totalSpacing) / numberOfItemsPerRow

            size = CGSize(width: width, height: 18)
        }
        
        return size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == hotelCollectionView {
            let pageWidth = scrollView.frame.width
            let fractionalPage = scrollView.contentOffset.x / pageWidth
            let page = Int(round(fractionalPage))
            if page != currentIndx {
                currentIndx = page
            }
        }
    }
}
