//
//  LocationViewController.swift
//  Fleen
//
//  Created by Mina Eid on 22/01/2024.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps

class LocationViewController: UIViewController ,CLLocationManagerDelegate, GMSMapViewDelegate{
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var workView: UIView!
    @IBOutlet weak var saveSwitch: UISwitch!
    @IBOutlet weak var headerView: HeaderView!
    
    var locationManager = CLLocationManager()
    var viewModel = LocationViewModel()
    var spinnerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupLocationManager()
        checkLocationExist()
        saveSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        bind()
        setAddressType()
        setupHeaderActions()
    }
    
    func bind() {
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
    
    @objc func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            viewModel.saved = 1
        } else {
            viewModel.saved = 0
        }
    }
    
    // MARK: - Location Services
    
    func setAddressType() {
        switch viewModel.addressType {
        case "1":
            updateViewColors(selectedView: homeView, otherView: workView, type: "1")
        case "2":
            updateViewColors(selectedView: workView, otherView: homeView, type: "2")
        default:
            break
        }
    }
    
    func checkLocationExist() {
        if let lat = viewModel.lat, let lon = viewModel.lon {
            locationTitleLabel.text = viewModel.addressType
            locationManager.stopUpdatingLocation()
            zoomToPassedLocation(lat: lat, lon: lon)
        } else {
            zoomToSaudiArabia()
            checkLocationServiceAuthorization()
        }
    }
    
    func zoomToPassedLocation(lat: Float, lon: Float) {
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
        mapView.camera = camera

        let marker = GMSMarker(position: coordinate)
        marker.title = "Selected Location"
        marker.map = mapView

        viewModel.lat = lat
        viewModel.lon = lon

        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        getLocationInfo(location: location)
    }
    
    func zoomToSaudiArabia() {
        let saudiCoordinate = CLLocationCoordinate2D(latitude: 23.8859, longitude: 45.0792)
        let camera = GMSCameraPosition.camera(withLatitude: saudiCoordinate.latitude, longitude: saudiCoordinate.longitude, zoom: 5.0)
        mapView.camera = camera
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.isMyLocationEnabled = true
    }
    
    private func checkLocationServiceAuthorization() {
        isLocationServiceEnabled { isEnabled in
            if isEnabled {
                self.checkAuthorization()
            } else {
                self.showAlert(msg: "Please allow location".localized)
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if viewModel.lat == nil, let location = locations.last {
            zoomToUserLocation(location: location)
            viewModel.lat = Float(location.coordinate.latitude)
            viewModel.lon = Float(location.coordinate.longitude)
            getLocationInfo(location: location)
            locationManager.stopUpdatingLocation()
        }
    }
    
    
    // MARK: - Helper Methods
    
    func showAlert(msg : String){
        let alert = UIAlertController(title: "Alert".localized, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close".localized, style: .default))
        alert.addAction(UIAlertAction(title: "Settings".localized, style: .default, handler: { action in
            
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        present(alert, animated: true)
    }
    
    func zoomToUserLocation(location : CLLocation){
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
        mapView.camera = camera
        
    }
    
    func getLocationInfo(location : CLLocation){
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { places, error in
            guard let place = places?.first , error == nil else { return }
            self.viewModel.address = "\(place.name ?? ""), \(place.locality ?? ""), \(place.administrativeArea ?? ""), \(place.country ?? "")"
            self.locationTitleLabel.text = "\(place.name ?? "") \(place.country ?? "")"
        }
    }
    
    func isLocationServiceEnabled(completion: @escaping (Bool) -> Void) {
        
        // Check if the service is enabled asynchronously
        DispatchQueue.global(qos: .background).async {
            let isEnabled = CLLocationManager.locationServicesEnabled()
            
            // Return the result on the main thread
            DispatchQueue.main.async {
                completion(isEnabled)
            }
        }
    }
    
    func checkAuthorization(){
        if #available(iOS 14.0, *) {
            switch locationManager.authorizationStatus {
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                mapView.isMyLocationEnabled = true
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
                mapView.isMyLocationEnabled = true
            case .denied:
                showAlert(msg: "Please allow the location".localized)
                break
            case .restricted:
                break
            @unknown default:
                print("default..")
                break
            }
        } else {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                mapView.isMyLocationEnabled = true
            case .denied:
                showAlert(msg: "Please allow the location".localized)
            default:
                break
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch locationManager.authorizationStatus {
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                mapView.isMyLocationEnabled = true
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
                mapView.isMyLocationEnabled = true
            case .denied:
                showAlert(msg: "Please allow the location")
                break
            case .restricted:
                showAlert(msg: "Authorization restricted")
                break
            @unknown default:
                print("default..")
                break
            }
        } else {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                mapView.isMyLocationEnabled = true
            case .denied:
                showAlert(msg: "Please allow the location")
            default:
                break
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        viewModel.lat = Float(coordinate.latitude)
        viewModel.lon = Float(coordinate.longitude)
        
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        getLocationInfo(location: location)
        
        mapView.clear()
        
        let marker = GMSMarker(position: coordinate)
        marker.title = "Selected Location"
        marker.map = mapView
    }
    
    
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapHomeBtn(_ sender: Any) {
        updateViewColors(selectedView: homeView, otherView: workView, type: "1")
    }
    
    
    @IBAction func didTapWorkBtn(_ sender: Any) {
        updateViewColors(selectedView: workView, otherView: homeView, type: "2")
    }
    
    func updateViewColors(selectedView: UIView, otherView: UIView, type: String) {
        selectedView.backgroundColor = .white
        otherView.backgroundColor = UIColor(hex: "F5F7F2")
        viewModel.addressType = type
    }
    
    @IBAction func didTapConfirmBtn(_ sender: Any) {
        
        if viewModel.lat != nil && viewModel.lon != nil {
            viewModel.addAddress { [weak self] result in
                self?.navigationController?.popViewController(animated: true)
            }
        } else {
            self.showAlert(msg: "Location services are not enabled.".localized)

        }
    }
}

