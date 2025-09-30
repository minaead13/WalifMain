//
//  AllOffersViewController.swift
//  Wlif
//
//  Created by OSX on 14/08/2025.
//

import UIKit

class AllOffersViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: HeaderView!
    
    let viewModel = AllOffersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        setCollectionView()
        bind()
        viewModel.fetchOffers()
        setupHeaderActions()
    }
    
    func setCollectionView() {
        switch viewModel.offersType {
          case .store:
              collectionView.registerCell(cell: StoreOfferDetailsCollectionViewCell.self)
          case .clinic, .hotel:
              collectionView.registerCell(cell: ClinicsOfferCollectionViewCell.self)
          }
      }

    func bind() {
        viewModel.onAllOffersFetched = { [weak self] in
            guard let self else { return }
            collectionView.reloadData()
            titleLabel.text = viewModel.setTitle()
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self,
                  let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self.showLoadingIndicator()
                } else {
                    self.hideLoadingIndicator()
                }
            }
        }
    }
    
    func setupHeaderActions() {
        headerView.onCartTap = { [weak self] in
            self?.navigate(to: CartViewController.self, from: "Home", storyboardID: "CartViewController")
        }
        
        headerView.onSideMenuTap = { [weak self] in
            self?.navigate(to: SettingsViewController.self, from: "Profile", storyboardID: "SettingsViewController")
        }
        
        headerView.onHomeTap = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AllOffersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.storeOffers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.offersType {
        case .store:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreOfferDetailsCollectionViewCell", for: indexPath) as? StoreOfferDetailsCollectionViewCell else { return UICollectionViewCell() }
            if let storeOffers = viewModel.storeOffers?[indexPath.row] {
                cell.store = storeOffers
            }
            return cell
            
        case .clinic, .hotel:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClinicsOfferCollectionViewCell", for: indexPath) as! ClinicsOfferCollectionViewCell
            if let clinicAndHotelOffers = viewModel.storeOffers?[indexPath.row] {
                cell.clinicOffer = clinicAndHotelOffers
            }
            return cell
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = 239.0
        if viewModel.offersType == .store {
            height = 265.0
        }
        return CGSize(width: collectionView.frame.width, height: height)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let offer = viewModel.storeOffers?[indexPath.row] else { return }
        switch viewModel.offersType {
        case .store:
            let vc = self.storyboard?.instantiateViewController(identifier: "OfferStoresDetailsViewController") as! OfferStoresDetailsViewController
            vc.viewModel.storeOffersDetails = offer
            self.navigationController?.pushViewController(vc, animated: true)
        case .clinic:
            let vc = self.storyboard?.instantiateViewController(identifier: "OfferClinicsDetailsVC") as! OfferClinicsDetailsVC
            vc.viewModel.storeOffersDetails = offer
            self.navigationController?.pushViewController(vc, animated: true)
        case .hotel:
            let vc = self.storyboard?.instantiateViewController(identifier: "OfferHotelDetailsVC") as! OfferHotelDetailsVC
            vc.viewModel.storeOffersDetails = offer
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
