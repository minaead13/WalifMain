//
//  ServicesTableViewCell.swift
//  Wlif
//
//  Created by OSX on 02/07/2025.
//

import UIKit
import Kingfisher

class ServicesTableViewCell: UITableViewCell {

    @IBOutlet weak var servicesCollectionView: UICollectionView!
    @IBOutlet weak var exploreCollectionView: UICollectionView!
    @IBOutlet weak var stepsCollectionView: UICollectionView!
    @IBOutlet weak var stepsWidthConst: NSLayoutConstraint!
    
    var handleSelection: ((String) -> Void)?
    var handleExploreSelection: (() -> Void)?
    let indexPath = IndexPath(item: 0, section: 0)
    private var selectedIndex: Int = 0
    var currentIndx: Int = 0 {
        didSet {
            stepsCollectionView.reloadData()
        }
    }
    
    let scrollPosition: UICollectionView.ScrollPosition = LanguageManager.shared.isRightToLeft ? .right : .left
    
    var services: [HomeService] = [] {
        didSet {
            selectedIndex = 0
            DispatchQueue.main.async {
                
                if self.servicesCollectionView.numberOfItems(inSection: 0) > 0 {
                    self.servicesCollectionView.scrollToItem(at: self.indexPath, at: self.scrollPosition, animated: false)
                }
            }
            servicesCollectionView.reloadData()
        }
    }
    
    var banners: [BannerModel] = [] {
        didSet {
            stepsWidthConst.constant = CGFloat((12 * banners.count) + 14)
            stepsCollectionView.reloadData()
            DispatchQueue.main.async {
                
                if self.stepsCollectionView.numberOfItems(inSection: 0) > 0 {
                    self.stepsCollectionView.scrollToItem(at: self.indexPath, at: self.scrollPosition, animated: false)
                }
                if self.exploreCollectionView.numberOfItems(inSection: 0) > 0 {
                    self.exploreCollectionView.scrollToItem(at: self.indexPath, at: .left, animated: false)
                }
            }
            exploreCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
    }

    func setCollectionView() {
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
        servicesCollectionView.registerCell(cell: ServiceCollectionViewCell.self)
        
        exploreCollectionView.registerCell(cell: PetsCollectionViewCell.self)
        exploreCollectionView.delegate = self
        exploreCollectionView.dataSource = self
        
        stepsCollectionView.registerCell(cell: StepCell.self)
        stepsCollectionView.delegate = self
        stepsCollectionView.dataSource = self
        
    }
    
    @IBAction func didTapSeeAllBtn(_ sender: Any) {
        handleExploreSelection?()
    }
    
}

extension ServicesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case servicesCollectionView:
            return services.count
        case exploreCollectionView, stepsCollectionView:
            return banners.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case servicesCollectionView:
            let cell = servicesCollectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCollectionViewCell", for: indexPath) as! ServiceCollectionViewCell
            cell.handleSelection = { [weak self] in
                self?.handleSelection?(self?.services[indexPath.row].slogan ?? "")
            }
            cell.setData(service: services[indexPath.row])
            
            return cell
            
        case exploreCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetsCollectionViewCell", for: indexPath) as? PetsCollectionViewCell else { return UICollectionViewCell() }
            cell.petsImageView.setImage(from: banners[indexPath.row].image)

            return cell
            
        case stepsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StepCell", for: indexPath) as? StepCell else { return UICollectionViewCell() }
            
            cell.backView.backgroundColor = UIColor(hex: "E9E9E9")
            cell.backView.cornerRadius = 3
            if indexPath.row == currentIndx {
                
                cell.backView.backgroundColor = .label
            } else {
                cell.backView.backgroundColor = UIColor(hex: "E9E9E9")
            }
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == servicesCollectionView {
            selectedIndex = indexPath.row
            collectionView.performBatchUpdates(nil, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
            case servicesCollectionView:
            let height: CGFloat = 152
            if  indexPath.row == selectedIndex {
                return CGSize(width: 123, height: height)
            } else {
                return CGSize(width: 74, height: height)
            }
        
        case exploreCollectionView:
            return CGSize(width: exploreCollectionView.frame.width - 70, height: 137)
            
        case stepsCollectionView:
            if indexPath.row == currentIndx {
                return CGSize(width: 12, height: 6)
            } else {
                return CGSize(width: 6, height: 6)
            }
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case servicesCollectionView, exploreCollectionView:
            return 8
        case stepsCollectionView:
            return 0
        default:
            return 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == exploreCollectionView {
            let pageWidth = scrollView.frame.width
            let fractionalPage = scrollView.contentOffset.x / pageWidth
            let page = Int(round(fractionalPage))
            if page != currentIndx {
                currentIndx = page
            }
        }
    }
}

