//
//  SearchResultViewController.swift
//  SearchResultViewController
//
//  Created by Hao Qin on 7/16/21.
//

import UIKit
import MapKit

protocol SearchResultViewControllerDelegate: AnyObject {
  func didTapResultCell(_ result: MKPlacemark, url: URL?)
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
    let address = item.formatAddress()
    
    cell.translatesAutoresizingMaskIntoConstraints = false
    cell.configure(
      with: SearchResultCellViewModel(
        name: name,
        address: address,
        distance: item.getDistanceFromUser(mapView: mapView),
        imageURL: nil))
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let placemark = searchResultItems[indexPath.row].placemark
    let name = placemark.name ?? "Unknown"
    let address = placemark.formatAddress()
    
    APICaller.shared.getImageUrl(for: name, location: address) { [weak self] result in
      switch result {
      case .success(let url):
        DispatchQueue.main.async {
          self?.delegate?.didTapResultCell(placemark, url: url)
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}
