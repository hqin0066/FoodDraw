//
//  RestaurantAnnotation.swift
//  RestaurantAnnotation
//
//  Created by Hao Qin on 7/18/21.
//

import UIKit
import MapKit

class RestaurantAnnotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  
  init(restaurant: Restaurant) {
    let coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
    
    self.coordinate = coordinate
    self.title = restaurant.name
  }
  
  init(placeMark: MKPlacemark) {
    self.coordinate = placeMark.coordinate
    self.title = placeMark.name
  }
}
