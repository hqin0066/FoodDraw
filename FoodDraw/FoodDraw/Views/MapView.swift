//
//  MapView.swift
//  FoodDraw
//
//  Created by Hao Qin on 7/15/21.
//

import UIKit
import MapKit
import CoreLocation

class MapView: UIView, CLLocationManagerDelegate {
  
  private let mapView = MKMapView()
  private let locationManager = CLLocationManager()
  
  private let addButton: UIButton = {
    let button = UIButton()
    
    let image = UIImage(systemName: "plus.circle.fill",
                        withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30)))
    button.setImage(image, for: .normal)
    button.tintColor = .systemGreen
    
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(mapView)
    setupConstraints()
    setupMap()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Setting Constraints
  private func setupConstraints() {
    mapView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: self.topAnchor),
      mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
  }
  
  // MARK: - Setting up the map
  private func setupMap() {
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      checkAuthorization()
    } else {
      // Show Setting Alert
    }
  }

  private func checkAuthorization() {
    switch locationManager.authorizationStatus {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .authorizedWhenInUse, .authorizedAlways:
      if let location = locationManager.location?.coordinate {
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
      }
      mapView.showsUserLocation = true
      mapView.isRotateEnabled = false
      mapView.showsBuildings = true
      locationManager.startUpdatingLocation()
    case .denied:
      break
    default:
      // show setting alert
      break
    }
  }
  
  // MARK: - Delegate
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkAuthorization()
  }
}
