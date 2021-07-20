//
//  HomeViewController.swift
//  FoodDraw
//
//  Created by Hao Qin on 7/14/21.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class HomeViewController: UIViewController {
  
  private var context: NSManagedObjectContext?

  private let mapView = MapView()
  
  private let addButton: UIButton = {
    let button = UIButton()
    
    let image = UIImage(systemName: "plus",
                        withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .bold)))
    button.setImage(image, for: .normal)
    button.tintColor = .white
    button.backgroundColor = .systemGreen
    button.layer.cornerRadius = 18
    
    return button
  }()
  
  private let drawButton: UIButton = {
    let button = UIButton()
    
    let image = UIImage(systemName: "arrow.clockwise",
                        withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 40, weight: .bold)))
    button.setImage(image, for: .normal)
    button.tintColor = .white
    button.backgroundColor = UIColor(named: "Gold")
    button.layer.cornerRadius = 35
    
    return button
  }()
  
  private let locateButton: UIButton = {
    let button = UIButton()
    
    let image = UIImage(systemName: "location.fill",
                        withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17)))
    button.setImage(image, for: .normal)
    button.tintColor = .white
    button.backgroundColor = UIColor(named: "Gold")
    button.layer.cornerRadius = 18
    
    return button
  }()
  
  private let searchViewController = SearchViewController()
  
  private var addToListDetailView = AddToListDetailView()
  private var selectedSearchResult: MKPlacemark? = nil
  private var imageUrl: URL? = nil
  private var selectedResultAnnotaton = MKPointAnnotation()
  
  private var restaurants: [Restaurant] = []
  
  private var restaurantDetailView = RestaurantDetailView()
  private var selectedSavedRestaurant: Restaurant? = nil
  
  private var drawResultView = DrawResultView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Home"
    
    context = Persistence.shared.container.viewContext
    fetchData()
    
    view.addSubview(mapView)
    view.addSubview(addButton)
    view.addSubview(drawButton)
    view.addSubview(locateButton)
    
    addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
    drawButton.addTarget(self, action: #selector(didTapDraw), for: .touchUpInside)
    locateButton.addTarget(self, action: #selector(didTapLocate), for: .touchUpInside)
    
    setupConstraints()
    
    mapView.delegate = self
    searchViewController.mapView = mapView.mapView
    searchViewController.delegate = self
    
    addToListDetailView.frame = CGRect(
      x: 0,
      y: self.view.frame.height,
      width: self.view.frame.width,
      height: self.view.frame.height / 2.5)
    view.addSubview(self.addToListDetailView)
    addToListDetailView.delegate = self
    
    restaurantDetailView.frame = CGRect(
      x: 0,
      y: self.view.frame.height,
      width: self.view.frame.width,
      height: self.view.frame.height / 2.5)
    view.addSubview(restaurantDetailView)
    restaurantDetailView.delegate = self
    
    drawResultView.frame = CGRect(
      x: 0,
      y: self.view.frame.height,
      width: self.view.frame.width,
      height: self.view.frame.height / 2.5)
    view.addSubview(drawResultView)
    drawResultView.delegate = self
    
    NotificationCenter.default.addObserver(self, selector: #selector(tableViewDidDeleteRows), name: .init("tableViewDidDeleteRows"), object: nil)
  }
  
  private func rotateButton() {
    UIView.animate(
      withDuration: 1.5,
      delay: 0,
      options: .curveEaseInOut) { [weak self] in
        guard let self = self else { return }
        self.drawButton.transform = CGAffineTransform(rotationAngle: -180)
      }
    
    UIView.animate(
      withDuration: 1.5,
      delay: 0,
      options: .curveEaseInOut) { [weak self] in
        guard let self = self else { return }
        self.drawButton.transform = CGAffineTransform(rotationAngle: -360)
      }
    
    UIView.animate(
      withDuration: 1.5,
      delay: 0,
      options: .curveEaseInOut) { [weak self] in
        guard let self = self else { return }
        self.drawButton.transform = CGAffineTransform.identity
      }
    
    UIView.animate(
      withDuration: 1.5,
      delay: 0,
      options: .curveEaseInOut) { [weak self] in
        guard let self = self else { return }
        self.drawButton.transform = CGAffineTransform(rotationAngle: -180)
      }
    
    UIView.animate(
      withDuration: 1.5,
      delay: 0,
      options: .curveEaseInOut) { [weak self] in
        guard let self = self else { return }
        self.drawButton.transform = CGAffineTransform(rotationAngle: -360)
      }
  }
  
  private func dismissViewsAndAnnotation() {
    self.mapView.mapView.removeAnnotation(selectedResultAnnotaton)
    
    UIView.animate(
      withDuration: 0.2,
      delay: 0,
      options: .curveEaseOut) { [weak self] in
        guard let self = self else { return }
        self.addToListDetailView.frame = CGRect(
          x: 0,
          y: self.view.frame.height,
          width: self.view.frame.width,
          height: self.view.frame.height / 2.5)
      }
    
    UIView.animate(
      withDuration: 0.2,
      delay: 0,
      options: .curveEaseOut) { [weak self] in
        guard let self = self else { return }
        self.drawResultView.frame = CGRect(
          x: 0,
          y: self.view.frame.height,
          width: self.view.frame.width,
          height: self.view.frame.height / 2.5)
      }
  }
  
  // MARK: - objc func
  @objc private func didTapAdd() {
    dismissViewsAndAnnotation()
    mapView.mapView.deselectAnnotation(mapView.mapView.selectedAnnotations.first, animated: true)
    let nav = UINavigationController(rootViewController: searchViewController)
    navigationController?.present(nav, animated: true)
  }
  
  @objc private func didTapDraw() {
    rotateButton()
    
    UIView.animate(
      withDuration: 1.5,
      delay: 0,
      options: .curveEaseInOut) { [weak self] in
        guard let self = self else { return }
        self.drawButton.transform = CGAffineTransform.identity
      } completion: { _ in
        guard let restaurant = self.restaurants.randomElement() else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.mapView.mapView.setRegion(region, animated: true)
        
        let location = CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
        let distance = self.mapView.mapView.userLocation.location?.distance(from: location) ?? 0
        let distanceInMile = (((distance / 1609) * 100).rounded()) / 100
        let distanceString = "\(distanceInMile)" + " miles"
        
        self.drawResultView.configure(with: SearchResultCellViewModel(
          name: restaurant.name ?? "Unknown",
          address: restaurant.address ?? "Unknown Address",
          distance: distanceString,
          imageURL: restaurant.imageUrl))
        
        UIView.animate(
          withDuration: 0.2,
          delay: 0,
          options: .curveEaseOut) {
            self.drawResultView.frame = CGRect(
              x: 0,
              y: self.view.frame.height - (self.view.frame.height / 2.5),
              width: self.view.frame.width,
              height: self.view.frame.height / 2.5)
          }
      }
  }
  
  @objc private func didTapLocate() {
    let userCoordinate = mapView.mapView.userLocation.coordinate
    let region = MKCoordinateRegion(center: userCoordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
    mapView.mapView.setRegion(region, animated: true)
  }
  
  @objc private func tableViewDidDeleteRows() {
    fetchData()
  }
  
  // MARK: - Setting Constraints
  private func setupConstraints() {
    mapView.translatesAutoresizingMaskIntoConstraints = false
    addButton.translatesAutoresizingMaskIntoConstraints = false
    drawButton.translatesAutoresizingMaskIntoConstraints = false
    locateButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      addButton.widthAnchor.constraint(equalToConstant: 36),
      addButton.heightAnchor.constraint(equalToConstant: 36),
      
      drawButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      drawButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
      drawButton.widthAnchor.constraint(equalToConstant: 70),
      drawButton.heightAnchor.constraint(equalToConstant: 70),
      
      locateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      locateButton.bottomAnchor.constraint(equalTo: drawButton.bottomAnchor),
      locateButton.widthAnchor.constraint(equalToConstant: 36),
      locateButton.heightAnchor.constraint(equalToConstant: 36)
    ])
  }
  
  // MARK: - CoreData
  private func fetchData() {
    var annotations: [RestaurantAnnotation] = []
    let request = NSFetchRequest<Restaurant>(entityName: "Restaurant")
    
    do {
      restaurants = try context!.fetch(request)
    } catch let error as NSError {
      print("Unsolved error when fetching data: \(error.userInfo)")
    }
    
    for restaurant in restaurants {
      let annotation = RestaurantAnnotation(restaurant: restaurant)
      annotations.append(annotation)
    }
    
    mapView.mapView.removeAnnotations(mapView.mapView.annotations)
    mapView.mapView.addAnnotations(annotations)
  }
}

// MARK: - Delegate
extension HomeViewController: MapViewDelegate {
  func mapViewDidSelectAnnotation(_ annotation: MKAnnotation) {
    
    guard annotation.title != selectedResultAnnotaton.title else { return }
    
    dismissViewsAndAnnotation()
    
    if let seletedRestaurant = (restaurants.filter {
      $0.longitude == annotation.coordinate.longitude && $0.latitude == annotation.coordinate.latitude
    }.first) {
      self.selectedSavedRestaurant = seletedRestaurant
      
      let location = CLLocation(latitude: seletedRestaurant.latitude, longitude: seletedRestaurant.longitude)
      let distance = mapView.mapView.userLocation.location?.distance(from: location) ?? 0
      let distanceInMile = (((distance / 1609) * 100).rounded()) / 100
      let distanceString = "\(distanceInMile)" + " miles"
      
      self.restaurantDetailView.configure(
        with: SearchResultCellViewModel(
          name: seletedRestaurant.name ?? "Unknown",
          address: seletedRestaurant.address ?? "Unknown Address",
          distance: distanceString,
          imageURL: seletedRestaurant.imageUrl))
      
      UIView.animate(
        withDuration: 0.2,
        delay: 0,
        options: .curveEaseOut) { [weak self] in
          guard let self = self else { return }
          self.restaurantDetailView.frame = CGRect(
            x: 0,
            y: self.view.frame.height - (self.view.frame.height / 2.5),
            width: self.view.frame.width,
            height: self.view.frame.height / 2.5)
        }
    }
  }
  
  func mapViewDidDeselectAnnotation(_ annotation: MKAnnotation) {
    UIView.animate(
      withDuration: 0.2,
      delay: 0,
      options: .curveEaseOut) { [weak self] in
        guard let self = self else { return }
        self.restaurantDetailView.frame = CGRect(
          x: 0,
          y: self.view.frame.height,
          width: self.view.frame.width,
          height: self.view.frame.height / 2.5)
      } completion: { [weak self] _ in
        guard let self = self else { return }
        self.selectedSavedRestaurant = nil
      }
  }
}

extension HomeViewController: SearchViewControllerDelegate {
  func didTapSearchResult(_ result: MKPlacemark, url: URL?) {
    navigationController?.dismiss(animated: true, completion: { [weak self] in
      guard let self = self else { return }
      
      self.selectedSearchResult = result
      self.imageUrl = url
      
      let region = MKCoordinateRegion(center: result.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
      self.selectedResultAnnotaton.coordinate = result.coordinate
      self.selectedResultAnnotaton.title = result.name
      
      self.mapView.mapView.addAnnotation(self.selectedResultAnnotaton)
      self.mapView.mapView.setRegion(region, animated: true)
      
      self.addToListDetailView.configure(
        with: SearchResultCellViewModel(
          name: result.name ?? "Unknown",
          address: result.formatAddress(),
          distance: result.getDistanceFromUser(mapView: self.mapView.mapView),
          imageURL: url))
      
      UIView.animate(
        withDuration: 0.2,
        delay: 0,
        options: .curveEaseOut) {
          self.addToListDetailView.frame = CGRect(
            x: 0,
            y: self.view.frame.height - (self.view.frame.height / 2.5),
            width: self.view.frame.width,
            height: self.view.frame.height / 2.5)
        }
    })
  }
}

extension HomeViewController: AddToListDetailViewDelegate {
  func didTapCancelButton() {
    mapView.mapView.removeAnnotation(self.selectedResultAnnotaton)
    
    let userCoordinate = mapView.mapView.userLocation.coordinate
    let region = MKCoordinateRegion(center: userCoordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
    mapView.mapView.setRegion(region, animated: true)
    
    UIView.animate(
      withDuration: 0.2,
      delay: 0,
      options: .curveEaseOut) { [weak self] in
        guard let self = self else { return }
        self.addToListDetailView.frame = CGRect(
          x: 0,
          y: self.view.frame.height,
          width: self.view.frame.width,
          height: self.view.frame.height / 2.5)
      } completion: { [weak self] _ in
        guard let self = self else { return }
        self.selectedSearchResult = nil
        self.imageUrl = nil
      }
  }
  
  func didTapSaveButton() {
    mapView.mapView.removeAnnotation(self.selectedResultAnnotaton)
    
    selectedResultAnnotaton.title = nil
    
    let savedLongitudes = restaurants.map { return $0.longitude }
    let savedlatitudes = restaurants.map { return $0.latitude }
    
    if !(savedLongitudes.contains(selectedSearchResult!.coordinate.longitude) &&
        savedlatitudes.contains(selectedSearchResult!.coordinate.latitude)) {
      Persistence.shared.createRestaurantWith(placeMark: selectedSearchResult!, imageUrl: imageUrl, using: context!)
      fetchData()
    }
    
    UIView.animate(
      withDuration: 0.2,
      delay: 0,
      options: .curveEaseOut) { [weak self] in
        guard let self = self else { return }
        self.addToListDetailView.frame = CGRect(
          x: 0,
          y: self.view.frame.height,
          width: self.view.frame.width,
          height: self.view.frame.height / 2.5)
      } completion: { [weak self] _ in
        guard let self = self else { return }
        self.selectedSearchResult = nil
        self.imageUrl = nil
      }
  }
}

extension HomeViewController: RestaurantDetailDetailViewDelegate {
  func didTapDeleteButton() {
    context?.delete(selectedSavedRestaurant!)
    
    do {
      try context?.save()
      print("Sucessfully saved to Core Data")
    } catch {
      fatalError("Unsolved error when saving data")
    }
    
    fetchData()
    
    UIView.animate(
      withDuration: 0.2,
      delay: 0,
      options: .curveEaseOut) { [weak self] in
        guard let self = self else { return }
        self.restaurantDetailView.frame = CGRect(
          x: 0,
          y: self.view.frame.height,
          width: self.view.frame.width,
          height: self.view.frame.height / 2.5)
      } completion: { [weak self] _ in
        guard let self = self else { return }
        self.selectedSavedRestaurant = nil
      }
  }
}

extension HomeViewController: DrawResultViewDelegate {
  func didTapRedrawButton() {
    UIView.animate(
      withDuration: 0.2,
      delay: 0,
      options: .curveEaseOut) {
        self.drawResultView.frame = CGRect(
          x: 0,
          y: self.view.frame.height,
          width: self.view.frame.width,
          height: self.view.frame.height / 2.5)
      } completion: { [weak self] _ in
        guard let self = self else { return }
        self.didTapDraw()
      }
  }
  
  func didTapDismissButton() {
    UIView.animate(
      withDuration: 0.2,
      delay: 0,
      options: .curveEaseOut) {
        self.drawResultView.frame = CGRect(
          x: 0,
          y: self.view.frame.height,
          width: self.view.frame.width,
          height: self.view.frame.height / 2.5)
      }
  }
}
