//
//  HomeViewController.swift
//  FoodDraw
//
//  Created by Hao Qin on 7/14/21.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {

  private let mapView: MapView = {
    let mapView = MapView()
    
    mapView.translatesAutoresizingMaskIntoConstraints = false
    
    return mapView
  }()
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Home"
    view.addSubview(mapView)
    view.addSubview(addButton)
    view.addSubview(drawButton)
    
    addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
    
    setupConstraints()
  }
  
  // MARK: - objc func
  @objc private func didTapAdd() {
    let vc = SearchViewController()
    vc.modalPresentationStyle = .pageSheet
    navigationController?.present(vc, animated: true)
  }
  
  // MARK: - Setting Constraints
  private func setupConstraints() {
    addButton.translatesAutoresizingMaskIntoConstraints = false
    drawButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
      addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
      drawButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      drawButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
      drawButton.widthAnchor.constraint(equalToConstant: 70),
      drawButton.heightAnchor.constraint(equalToConstant: 70)
    ])
  }
}
