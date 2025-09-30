//
//  HeaderTableViewCell.swift
//  Wlif
//
//  Created by OSX on 02/07/2025.
//

import UIKit
import HSCycleGalleryView

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerView: HeaderView!
    
    let pager =  HSCycleGalleryView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 170))
    
    var banners: [BannerModel] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self, self.banners.count > 0 else { return }
                setView()
                pager.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = "\("Hi".localized) \(UserUtil.load()?.user?.name ?? "")"
    }
    
    func setView() {
        pager.register(nib: UINib(nibName: "PetsCollectionViewCell", bundle: nil), forCellReuseIdentifier: "PetsCollectionViewCell")
        pager.delegate = self
        pager.backgroundColor = .clear
        pager.subviews.forEach { $0.backgroundColor = .clear }
        containerView.addSubview(pager)
    }

}

extension HeaderTableViewCell: HSCycleGalleryViewDelegate {
    
    func numberOfItemInCycleGalleryView(_ cycleGalleryView: HSCycleGalleryView) -> Int {
        return banners.count
    }
    
    func cycleGalleryView(_ cycleGalleryView: HSCycleGalleryView, cellForItemAtIndex index: Int) -> UICollectionViewCell {
        guard let cell = cycleGalleryView.dequeueReusableCell(withIdentifier: "PetsCollectionViewCell", for: IndexPath(item: index, section: 0)) as? PetsCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .clear
        cell.petsImageView.setImage(from: banners[index].image)
        
        return cell
    }
}
