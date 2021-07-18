//
//  SearchResultTableViewCell.swift
//  SearchResultTableViewCell
//
//  Created by Hao Qin on 7/16/21.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
  static let reuseIdentifier = String(describing: SearchResultTableViewCell.self)
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.clipsToBounds = true
    
    return label
  }()
  
  private let addressLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textColor = .secondaryLabel
    label.clipsToBounds = true
    
    return label
  }()
  
  private let distanceLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textColor = .secondaryLabel
    label.clipsToBounds = true
    
    return label
  }()
  
  private let restaurantImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "magnifyingglass.circle")
    imageView.tintColor = UIColor(named: "Gold")
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    
    return imageView
  }()
  
  private let containerView: UIView = {
    let view = UIView()
    view.clipsToBounds = true
    
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    containerView.addSubview(nameLabel)
    containerView.addSubview(addressLabel)
    containerView.addSubview(distanceLabel)
    contentView.addSubview(containerView)
    contentView.addSubview(restaurantImageView)
    
    setupContraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    nameLabel.text = nil
    addressLabel.text = nil
  }
  
  private func setupContraints() {
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    addressLabel.translatesAutoresizingMaskIntoConstraints = false
    distanceLabel.translatesAutoresizingMaskIntoConstraints = false
    restaurantImageView.translatesAutoresizingMaskIntoConstraints = false
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      restaurantImageView.widthAnchor.constraint(equalToConstant: 30),
      restaurantImageView.heightAnchor.constraint(equalToConstant: 30),
      restaurantImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
      restaurantImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
      
      containerView.heightAnchor.constraint(equalToConstant: 60),
      containerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
      containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 50),
      containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
      
      nameLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
      nameLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
      
      addressLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor),
      addressLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
      addressLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
      
      distanceLabel.topAnchor.constraint(equalTo: self.addressLabel.bottomAnchor),
      distanceLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
      distanceLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
    ])
  }
  
  func configure(with viewModel: SearchResultCellViewModel) {
    nameLabel.text = viewModel.name
    addressLabel.text = viewModel.address
    distanceLabel.text = viewModel.distance
  }
}
