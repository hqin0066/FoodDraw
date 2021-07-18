//
//  HomeViewController.swift
//  FoodDraw
//
//  Created by Hao Qin on 7/14/21.
//

import UIKit
import CoreLocation
import MapKit

class HomeViewController: UIViewController {

  private let mapView = MapView()
  
  private let addButton: UIButton = {
    let button = UIButton()
    
    let image = UIImage(systemName: "plus.circle.fill",
                        withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30)))
    button.setImage(image, for: .normal)
    button.tintColor = .systemGreen
    
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
  
  private let searchViewController = SearchViewController()
  
  private var addToListDetailView = AddToListDetailView()
  
  private var selectedResult: MKPlacemark? = nil
  private var selectedResultAnnotaton = MKPointAnnotation()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Home"
    view.addSubview(mapView)
    view.addSubview(addButton)
    view.addSubview(drawButton)
    
    addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
    
    setupConstraints()
    
    searchViewController.mapView = mapView.mapView
    searchViewController.delegate = self
    
    self.addToListDetailView.frame = CGRect(
      x: 0,
      y: self.view.frame.height,
      width: self.view.frame.width,
      height: self.view.frame.height / 2.5)
    view.addSubview(self.addToListDetailView)
    addToListDetailView.delegate = self
  }
  
  // MARK: - objc func
  @objc private func didTapAdd() {
    let nav = UINavigationController(rootViewController: searchViewController)
    navigationController?.present(nav, animated: true)
  }
  
  // MARK: - Setting Constraints
  private func setupConstraints() {
    mapView.translatesAutoresizingMaskIntoConstraints = false
    addButton.translatesAutoresizingMaskIntoConstraints = false
    drawButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      drawButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      drawButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
      drawButton.widthAnchor.constraint(equalToConstant: 70),
      drawButton.heightAnchor.constraint(equalToConstant: 70)
    ])
  }
}

// MARK: - Delegate
extension HomeViewController: SearchViewControllerDelegate {
  func didTapSearchResult(_ result: MKPlacemark, url: URL?) {
    navigationController?.dismiss(animated: true, completion: { [weak self] in
      guard let self = self else { return }
      
      self.selectedResult = result
      
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
        options: .curveEaseOut) { [weak self] in
          guard let self = self else { return }
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
      }
  }
  
  func didTapSaveButton() {
    
  }
}
