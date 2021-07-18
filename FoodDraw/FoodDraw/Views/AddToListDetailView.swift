//
//  AddToListDetailView.swift
//  AddToListDetailView
//
//  Created by Hao Qin on 7/17/21.
//

import UIKit

protocol AddToListDetailViewDelegate: AnyObject {
  func didTapCancelButton()
  func didTapSaveButton()
}

class AddToListDetailView: UIView {
  
  weak var delegate: AddToListDetailViewDelegate?
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 20, weight: .bold)
    label.clipsToBounds = true
    
    return label
  }()
  
  private let addressLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.font = .systemFont(ofSize: 17)
    label.clipsToBounds = true
    
    return label
  }()
  
  private let distanceLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = .systemFont(ofSize: 17)
    label.textColor = .secondaryLabel
    label.clipsToBounds = true
    
    return label
  }()
  
  private let restaurantImageView: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFill
    image.clipsToBounds = true
    image.layer.cornerRadius = 15
    
    return image
  }()
  
  private let cancelButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Cancel", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
    button.layer.cornerRadius = 17
    button.backgroundColor = UIColor(named: "Gold")
    button.clipsToBounds = true
    
    return button
  }()
  
  private let saveButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Add to list", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
    button.layer.cornerRadius = 17
    button.backgroundColor = UIColor(named: "Gold")
    button.clipsToBounds = true
    
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    setupBackground()
    addSubview(titleLabel)
    addSubview(addressLabel)
    addSubview(distanceLabel)
    addSubview(restaurantImageView)
    addSubview(cancelButton)
    addSubview(saveButton)
    setupConstraints()
    
    cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
    saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func setupBackground() {
    backgroundColor = .systemBackground
    layer.cornerRadius = 15
    layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOpacity = 0.6
    layer.shadowOffset = .zero
    layer.shadowRadius = 4
  }
  
  @objc private func didTapCancel() {
    self.delegate?.didTapCancelButton()
  }
  
  @objc private func didTapSave() {
    self.delegate?.didTapSaveButton()
  }
  
  private func setupConstraints() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    addressLabel.translatesAutoresizingMaskIntoConstraints = false
    distanceLabel.translatesAutoresizingMaskIntoConstraints = false
    restaurantImageView.translatesAutoresizingMaskIntoConstraints = false
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    saveButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      restaurantImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 5),
      restaurantImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 5),
      restaurantImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      restaurantImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      
      titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: self.restaurantImageView.trailingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      
      addressLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
      addressLabel.leadingAnchor.constraint(equalTo: self.restaurantImageView.trailingAnchor, constant: 10),
      addressLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      
      distanceLabel.topAnchor.constraint(equalTo: self.addressLabel.bottomAnchor, constant: 10),
      distanceLabel.leadingAnchor.constraint(equalTo: self.restaurantImageView.trailingAnchor, constant: 10),
      
      cancelButton.widthAnchor.constraint(equalToConstant: 150),
      cancelButton.heightAnchor.constraint(equalToConstant: 34),
      cancelButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      
      saveButton.widthAnchor.constraint(equalToConstant: 150),
      saveButton.heightAnchor.constraint(equalToConstant: 34),
      saveButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
    ])
  }
  
  func configure(with viewModel: SearchResultCellViewModel) {
    titleLabel.text = viewModel.name
    addressLabel.text = viewModel.address
    distanceLabel.text = viewModel.distance
    
    APICaller.shared.downloadImage(with: viewModel.imageURL) { [weak self] image in
      DispatchQueue.main.async {
        if let image = image {
          self?.restaurantImageView.image = image
        } else {
          self?.restaurantImageView.image = UIImage(systemName: "photo")
        }
      }
    }
  }
}
