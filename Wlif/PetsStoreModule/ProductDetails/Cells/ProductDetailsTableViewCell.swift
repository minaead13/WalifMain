//
//  ProductDetailsTableViewCell.swift
//  Wlif
//
//  Created by OSX on 09/07/2025.
//

import UIKit
import Cosmos

class ProductDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productDetailsImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var priceBeforeLabel: UILabel!
    @IBOutlet weak var priceBeforeView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    var updateQnty: ((_ action: QtyAction,_ qnty: Int)->())?
    
    var qtyAmount: Int = 0 {
        didSet {
            qtyLabel.text = "\(qtyAmount)"
            minusBtn.isHidden = qtyAmount <= 0
        }
    }
    
    var productDetails: ProcutDetailsModel? {
        didSet {
            guard let details = productDetails else { return }
            
            // Configure product image
            if let urlString = details.product?.image,
               let url = URL(string: urlString) {
                productDetailsImageView.kf.setImage(with: url)
            }
            
            // Configure product labels
            nameLabel.text = details.product?.name ?? ""
            descLabel.text = details.product?.desc ?? ""
            priceLabel.text = "\(details.product?.price ?? 0)"
            
            // Configure store image
            if let urlString = details.store?.image,
               let url = URL(string: urlString) {
                storeImageView.kf.setImage(with: url)
            }
            
            // Configure store labels
            storeNameLabel.text = details.store?.name ?? ""
            
            
            // Configure rating
            ratingView.rating = Double(details.store?.rate ?? 0)
            rateLabel.text = "(\(details.store?.rate ?? 0))"
            
            // Configure price before
            if let priceBefore = details.product?.priceBefore {
                priceBeforeLabel.text = "\(priceBefore)"
                priceBeforeView.isHidden = false
            } else {
                priceBeforeView.isHidden = true
            }
            
            sizeCollectionView.reloadData()
            colorCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        sizeCollectionView.delegate = self
        sizeCollectionView.dataSource = self
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        sizeCollectionView.registerCell(cell: SizeCollectionViewCell.self)
        colorCollectionView.registerCell(cell: ColorCollectionViewCell.self)
    }

    
    @IBAction func didTapMinusButton(_ sender: Any) {
        qtyAmount -= 1
        updateQnty?(.decrease, qtyAmount)
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        qtyAmount += 1
        updateQnty?(.increase, qtyAmount)
    }
    
    
}

extension ProductDetailsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case sizeCollectionView:
            return productDetails?.product?.sizes?.count ?? 0
            
        case colorCollectionView:
            return productDetails?.product?.colors?.count ?? 0
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case sizeCollectionView:
            guard let cell = sizeCollectionView.dequeueReusableCell(withReuseIdentifier: "SizeCollectionViewCell", for: indexPath) as? SizeCollectionViewCell else { return UICollectionViewCell() }
            
            cell.sizeLabel.text = productDetails?.product?.sizes?[indexPath.row].size
            return cell
            
        case colorCollectionView:
            guard let cell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as? ColorCollectionViewCell else { return UICollectionViewCell() }
            
            cell.colorView.backgroundColor = UIColor(hexString: productDetails?.product?.colors?[indexPath.row].color ?? "")
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
            
        case sizeCollectionView:
            return CGSize(width: 80, height: sizeCollectionView.frame.height)
            
        case colorCollectionView:
            return CGSize(width: 46, height: sizeCollectionView.frame.height)
            
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
