//
//  Extension.swift
//  FoodDraw
//
//  Created by Hao Qin on 7/14/21.
//

import UIKit
import MapKit

extension MKPlacemark {
  func formatAddress() -> String {
    if let streetNumber = self.subThoroughfare,
       let street = self.thoroughfare,
       let city = self.locality,
       let state = self.administrativeArea,
       let zipCode = self.postalCode {
      return streetNumber + " " + street + ", " + city + ", " + state + " " + zipCode
    } else {
      return "Unknown Address"
    }
  }
  
  func getDistanceFromUser(mapView: MKMapView?) -> String {
    let location = self.location
    let userLocation = mapView?.userLocation.location ?? CLLocation()
    let distance = location?.distance(from: userLocation) ?? 0
    let distanceInMile = (((distance / 1609) * 100).rounded()) / 100
    
    return "\(distanceInMile)" + " miles"
  }
}
