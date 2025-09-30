//
//  HotelBookingTableViewCell.swift
//  Wlif
//
//  Created by OSX on 29/07/2025.
//

import UIKit

class HotelBookingTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noOfAnimalsTextField: UITextField!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var roomPriceLabel: UILabel!
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    @IBOutlet weak var servicesCollectionViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var roomView: UIView!
    @IBOutlet weak var roomContainerViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var selectStack: UIStackView!
    
    var services: [Service] = [] {
        didSet {
            let layout = servicesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
            let lineSpacing = layout?.minimumLineSpacing ?? 8
            let sectionInsets = layout?.sectionInset ?? .zero
            let rowHeight: CGFloat = 16

            let serviceCount = services.count
    
            let numberOfRows = ceil(CGFloat(serviceCount) / 1)

            let totalHeight =
                (numberOfRows * rowHeight) +
                ((numberOfRows - 1) * lineSpacing) +
                sectionInsets.top + sectionInsets.bottom

            servicesCollectionViewHeightConstant.constant = totalHeight
            servicesCollectionView.reloadData()
        }
    }
    
    
    var handleSelectionDate: (() -> Void)?
    var handleSelectionRoom: (() -> Void)?
    var onAnimalsTextChanged: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        noOfAnimalsTextField.delegate = self
        noOfAnimalsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setupCollectionView() {
        servicesCollectionView.registerCell(cell: AvailableServiceCollectionViewCell.self)
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
     }

    @objc func textFieldDidChange(_ textField: UITextField) {
        onAnimalsTextChanged?(textField.text ?? "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapDataBtn(_ sender: Any) {
        handleSelectionDate?()
    }
    
    
    @IBAction func didTapRoomsBtn(_ sender: Any) {
        handleSelectionRoom?()
    }
}

extension HotelBookingTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailableServiceCollectionViewCell", for: indexPath) as? AvailableServiceCollectionViewCell else { return UICollectionViewCell() }
        cell.serviceLabel.text = services[indexPath.row].name
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 16)
    }
    
}
