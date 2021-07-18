//
//  SearchViewController.swift
//  FoodDraw
//
//  Created by Hao Qin on 7/15/21.
//

import UIKit
import MapKit

protocol SearchViewControllerDelegate: AnyObject {
  func didTapSearchResult(_ result: MKPlacemark, url: URL?)
}

class SearchViewController: UIViewController {
  
  weak var delegate: SearchViewControllerDelegate?
  
  var mapView: MKMapView? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Add Favourite"
    view.backgroundColor = .systemBackground
    
    let searchResultViewController = SearchResultViewController()
    let searchController = UISearchController(searchResultsController: searchResultViewController)
    
    searchController.searchBar.sizeToFit()
    searchController.searchBar.searchBarStyle = .minimal
    searchController.searchBar.placeholder = "Search for restaurants"
    searchController.definesPresentationContext = true
    
    searchController.searchResultsUpdater = searchResultViewController
    
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    
    searchResultViewController.mapView = mapView
    searchResultViewController.delegate = self
  }
}

// MARK: - Delegate
extension SearchViewController: SearchResultViewControllerDelegate {
  func didTapResultCell(_ result: MKPlacemark, url: URL?) {
    delegate?.didTapSearchResult(result, url: url)
  }
}
