//
//  HomeViewController.swift
//  Wlif
//
//  Created by OSX on 02/07/2025.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let homeViewModel = HomeViewModel()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setTableView()
        bind()
        homeViewModel.getServices()
        locationManager.delegate = self
        checkLocationAuthorizationStatus()
    }
    
    func setTableView() {
        tableView.registerCell(cell: HeaderTableViewCell.self)
        tableView.registerCell(cell: ServicesTableViewCell.self)
        tableView.registerCell(cell: AddoptionOffersTableViewCell.self)
    }
    
    func bind() {
        homeViewModel.onServicesFetched = { [weak self] services in
            self?.tableView.reloadData()
        }
        
        homeViewModel.isLoading.bind { [weak self] isLoading in
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
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as? HeaderTableViewCell else { return UITableViewCell() }
            
            cell.headerView.onCartTap = { [weak self] in
                self?.navigate(to: CartViewController.self, from: "Home", storyboardID: "CartViewController")
            }
            
            cell.headerView.onSideMenuTap = { [weak self] in
                self?.navigate(to: SettingsViewController.self, from: "Profile", storyboardID: "SettingsViewController")
            }
            
            cell.locationLabel.text = LocationUtil.load()?.address
            cell.banners = homeViewModel.homeData?.banners ?? []
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ServicesTableViewCell", for: indexPath) as! ServicesTableViewCell
            cell.services = homeViewModel.homeData?.services ?? []
            cell.banners = homeViewModel.homeData?.banners ?? []
            
            cell.handleSelection = { [weak self] slogan in
                let service = Services(rawValue: slogan)
                self?.navigate(to: service ?? .unknown)
            }
            
            cell.handleExploreSelection = { [weak self] in
                let storyboard = UIStoryboard(name: "Explore", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "OfferViewController") as! OfferViewController
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.selectionStyle = .none
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddoptionOffersTableViewCell", for: indexPath) as! AddoptionOffersTableViewCell
            cell.adoptionOffers = homeViewModel.homeData?.adoptionOffers ?? []
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        
        setLocation(userLocation)
        
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if (LocationUtil.load() == nil) {
            checkLocationAuthorizationStatus()
        }
    }
    
    func checkLocationAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("no location")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func setLocation(_ userLocation:CLLocation) {
        let geocoder = CLGeocoder()
        let currentLang = LanguageManager.shared.currentLanguage == .en ? "en" : "ar"
        geocoder.accessibilityLanguage = currentLang
        geocoder.reverseGeocodeLocation(userLocation) { [weak self] response, error in
            guard let self else { return }
            guard error == nil else { return }
            guard let place = response?.first else { return }
            
            let address = AddressModel(address: "\(place.thoroughfare ?? "") \(place.subLocality ?? "") \(place.locality ?? "")".trimmingCharacters(in: .whitespacesAndNewlines), lat: "\(place.location?.coordinate.latitude ?? 0 )", lon: "\(place.location?.coordinate.longitude ?? 0 )")
            
            LocationUtil.save(address)
        }
    }
}
