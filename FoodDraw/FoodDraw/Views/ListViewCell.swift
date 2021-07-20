//
//  ListViewCell.swift
//  ListViewCell
//
//  Created by Hao Qin on 7/19/21.
//

import UIKit

class ListViewCell: UITableViewCell {
  static let reuseIdentifier = String(describing: ListViewCell.self)
  
  private let restaurantImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.tintColor = UIColor(named: "Gold")
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 15
    
    return imageView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 17, weight: .bold)
    label.numberOfLines = 0
    label.clipsToBounds = true
    
    return label
  }()
  
  private let addressLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.numberOfLines = 0
    label.clipsToBounds = true
    
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(restaurantImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(addressLabel)
    
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func prepareForReuse() {
    
  }
  
  private func setupConstraints() {
    restaurantImageView.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    addressLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      restaurantImageView.widthAnchor.constraint(equalToConstant: 90),
      restaurantImageView.heightAnchor.constraint(equalToConstant: 90),
      restaurantImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      restaurantImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      
      nameLabel.topAnchor.constraint(equalTo: restaurantImageView.topAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: 10),
      nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      
      addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
      addressLabel.leadingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: 10),
      addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
    ])
  }
  
  func configure(with viewModel: ListViewCellViewModel) {
    nameLabel.text = viewModel.name
    addressLabel.text = viewModel.address
    
    APICaller.shared.downloadImage(with: viewModel.imageUrl) { [weak self] image in
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
