//
//  Persistance.swift
//  Persistance
//
//  Created by Hao Qin on 7/18/21.
//

import Foundation
import CoreData
import MapKit

final class Persistence {
  static let shared = Persistence()
  
  let container: NSPersistentContainer
  
  private init() {
    container = NSPersistentContainer(name: "FoodDraw")
    
    container.loadPersistentStores { storeDescription, error in
      if let error = error as NSError? {
        fatalError("Unsolved Core Data error: \(error.userInfo)")
      }
    }
  }
  
  func createRestaurantWith(placeMark: MKPlacemark, imageUrl: URL?, using context: NSManagedObjectContext) {
    let restaurant = Restaurant(context: context)
    restaurant.name = placeMark.name
    restaurant.longitude = placeMark.coordinate.longitude
    restaurant.latitude = placeMark.coordinate.latitude
    restaurant.imageUrl = imageUrl
    
    do {
      try context.save()
      print("Sucessfully saved to Core Data")
    } catch {
      fatalError("Unsolved error when saving data")
    }
  }
}
