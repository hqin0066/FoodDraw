//
//  SearchResultTableViewCell.swift
//  SearchResultTableViewCell
//
//  Created by Hao Qin on 7/16/21.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
  static let reuseIdentifier = String(describing: SearchResultTableViewCell.self)
  
  private let title: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.clipsToBounds = true
    
    return label
  }()
  
  private let address: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textColor = .secondaryLabel
    label.clipsToBounds = true
    
    return label
  }()
  
  private let restaurantImageView: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    image.clipsToBounds = true
    
    return image
  }()
  
  private let containerView: UIView = {
    let view = UIView()
    view.clipsToBounds = true
    
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    containerView.addSubview(title)
    containerView.addSubview(address)
    contentView.addSubview(containerView)
    contentView.addSubview(restaurantImageView)
    setupContraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    
  }
  
  override func prepareForReuse() {
    title.text = nil
    address.text = nil
    restaurantImageView.image = nil
  }
  
  private func setupContraints() {
    title.translatesAutoresizingMaskIntoConstraints = false
    address.translatesAutoresizingMaskIntoConstraints = false
    restaurantImageView.translatesAutoresizingMaskIntoConstraints = false
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      restaurantImageView.widthAnchor.constraint(equalToConstant: 50),
      restaurantImageView.heightAnchor.constraint(equalToConstant: 50),
      restaurantImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
      restaurantImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
      
      containerView.heightAnchor.constraint(equalToConstant: 40),
      containerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
      containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 70),
      containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
      
      title.topAnchor.constraint(equalTo: self.containerView.topAnchor),
      title.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
      title.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
      
      address.topAnchor.constraint(equalTo: self.title.bottomAnchor),
      address.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
      address.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
    ])
  }
  
  func configure(with viewModel: SearchResultCellViewModel) {
    title.text = viewModel.name
    address.text = viewModel.address
    restaurantImageView.image = UIImage(systemName: "magnifyingglass")
  }
}
