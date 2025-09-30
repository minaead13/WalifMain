//
//  AdoptionDetailsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 13/07/2025.
//

import UIKit

class AdoptionDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var bloodTypeLabel: UILabel!
    @IBOutlet weak var petsCollectionView: UICollectionView!
    @IBOutlet weak var stepsCollectionView: UICollectionView!
    @IBOutlet weak var stepsWidthConst: NSLayoutConstraint!
    @IBOutlet weak var likeBtn: UIButton!
    
    var handleLikeSelection: (() -> Void)?
    
    var attachements: [String] = [] {
        didSet {
            petsCollectionView.reloadData()
            stepsWidthConst.constant = CGFloat((14 * attachements.count) + 14)
            stepsCollectionView.reloadData()
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: 0, section: 0)
                let scrollPosition: UICollectionView.ScrollPosition = LanguageManager.shared.isRightToLeft ? .right : .left
                
                if self.stepsCollectionView.numberOfItems(inSection: 0) > 0 {
                    self.stepsCollectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: false)
                }
                
                if self.petsCollectionView.numberOfItems(inSection: 0) > 0 {
                    self.petsCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
                }
            }

        }
    }
    
    var currentIndx: Int = 0 {
        didSet {
            stepsCollectionView.reloadData()
        }
    }
    
    var handleSelection: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func configure(data: AdoptionDetailsModel) {
        petNameLabel.text = data.petName
        descLabel.text = data.distance
        locationLabel.text = data.location
        distanceLabel.text = data.distance
        ageLabel.text = data.age
        bloodTypeLabel.text = data.bloodType
        attachements = data.attachments ?? []
        likeBtn.setImage(UIImage(named: data.isFav ?? false ? "heart.fill" : "love"), for: .normal)
    }

   func setupCollectionView() {
       petsCollectionView.registerCell(cell: PetsCollectionViewCell.self)
       petsCollectionView.delegate = self
       petsCollectionView.dataSource = self
       
       stepsCollectionView.registerCell(cell: StepCell.self)
       stepsCollectionView.delegate = self
       stepsCollectionView.dataSource = self
    }
    
    @IBAction func didTapCommunicateBtn(_ sender: Any) {
        handleSelection?()
    }
    
    @IBAction func didTapLikeBtn(_ sender: Any) {
        handleLikeSelection?()
    }
    
    
}

extension AdoptionDetailsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == petsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetsCollectionViewCell", for: indexPath) as? PetsCollectionViewCell else { return UICollectionViewCell() }
            cell.petsImageView.setImage(from: attachements[indexPath.row])
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StepCell", for: indexPath) as? StepCell else { return UICollectionViewCell() }
            
            cell.backView.backgroundColor = UIColor(hex: "E9E9E9")
            
            if indexPath.row == currentIndx {
                cell.backView.backgroundColor = .label
            } else {
                cell.backView.backgroundColor = UIColor(hex: "E9E9E9")
            }
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: 0, height: 0)
        
        if collectionView == petsCollectionView {
            size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            size = CGSize(width: 12, height: 4)
        }
        
        return size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == petsCollectionView {
            let pageWidth = scrollView.frame.width
            let fractionalPage = scrollView.contentOffset.x / pageWidth
            let page = Int(round(fractionalPage))
            if page != currentIndx {
                currentIndx = page
            }
        }
    }
}
