//
//  SearchResultViewController.swift
//  SearchResultViewController
//
//  Created by Hao Qin on 7/16/21.
//

import UIKit
import MapKit

protocol SearchResultViewControllerDelegate: AnyObject {
  func didTapResultCell(_ result: MKPlacemark)
}

class SearchResultViewController: UIViewController {
  
  weak var delegate: SearchResultViewControllerDelegate?
  
  var mapView: MKMapView? = nil
  var searchResultItems: [MKMapItem] = []
  
  private let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(
      SearchResultTableViewCell.self,
      forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    tableView.frame = view.bounds
  }
  
  private func formatAddress(with placemark: MKPlacemark) -> String {
    if let streetNumber = placemark.subThoroughfare,
       let street = placemark.thoroughfare,
       let city = placemark.locality,
       let state = placemark.administrativeArea,
       let zipCode = placemark.postalCode {
      return streetNumber + " " + street + ", " + city + ", " + state + " " + zipCode
    } else {
      return "Unknown Address"
    }
  }
}

// MARK: - Delegate
extension SearchResultViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let mapView = mapView,
          let searchBarText = searchController.searchBar.text else { return }
    
    let searchRequest = MKLocalSearch.Request(completion: MKLocalSearchCompletion())
    let filter = MKPointOfInterestFilter(including: [.restaurant])
    searchRequest.naturalLanguageQuery = searchBarText
    searchRequest.region = mapView.region
    searchRequest.pointOfInterestFilter = filter
    
    let search = MKLocalSearch(request: searchRequest)
    search.start { [weak self] response, _ in
      guard let response = response,
            let self = self else { return }
      self.searchResultItems = response.mapItems
      self.tableView.reloadData()
    }
  }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResultItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseIdentifier, for: indexPath) as? SearchResultTableViewCell else {
      return UITableViewCell()
    }
    
    let item = searchResultItems[indexPath.row].placemark
    let name = item.name ?? "Unknown"
    let address = formatAddress(with: item)
    
    let location = item.location
    let userLocation = mapView?.userLocation.location ?? CLLocation()
    let distance = location?.distance(from: userLocation) ?? 0
    let distanceInMile = (((distance / 1609) * 100).rounded()) / 100
    let distanceString = "\(distanceInMile)" + " miles"
    
    cell.translatesAutoresizingMaskIntoConstraints = false
    cell.configure(with: SearchResultCellViewModel(name: name, address: address, distance: distanceString, imageURL: nil))
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let result = searchResultItems[indexPath.row].placemark
    
    delegate?.didTapResultCell(result)
  }
}
