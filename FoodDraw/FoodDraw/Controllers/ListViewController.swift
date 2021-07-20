//
//  ListViewController.swift
//  FoodDraw
//
//  Created by Hao Qin on 7/14/21.
//

import UIKit
import CoreData

class ListViewController: UIViewController {
  
  var context: NSManagedObjectContext?
  
  private let tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    
    return tableView
  }()
  
  private lazy var fetchResultsController: NSFetchedResultsController<Restaurant> = {
    let request = NSFetchRequest<Restaurant>(entityName: "Restaurant")
    let sortDescriptor = NSSortDescriptor(key: "addedDate", ascending: false)
    request.sortDescriptors = [sortDescriptor]
    
    let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
    frc.delegate = self
    
    return frc
  }()
  
  private lazy var dataSource: ListViewUITableDataSource = {
    let dataSource = ListViewUITableDataSource(tableView: tableView) { [weak self] (tableView, indexPath, objectId) -> UITableViewCell? in
      guard let self = self,
            let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.reuseIdentifier, for: indexPath) as? ListViewCell,
            let object = try? self.context?.existingObject(with: objectId) as? Restaurant else {
              return UITableViewCell()
            }
      
      cell.configure(with: ListViewCellViewModel(
        name: object.name ?? "Unknown",
        address: object.address ?? "Unknown Address",
        imageUrl: object.imageUrl))
      
      return cell
    }
    
    tableView.dataSource = dataSource
    dataSource.delegate = self
    
    return dataSource
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "List"
    
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.register(ListViewCell.self, forCellReuseIdentifier: ListViewCell.reuseIdentifier)
    
    context = Persistence.shared.container.viewContext
    do {
      try fetchResultsController.performFetch()
    } catch {
      fatalError("Unsolved error when fetch Core Data for list")
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    tableView.frame = view.bounds
  }
}

// MARK: - Delegate
extension ListViewController: NSFetchedResultsControllerDelegate {
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
    let listSnapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
    dataSource.apply(listSnapshot)
  }
}

extension ListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension ListViewController: ListViewUITableDataSourceDelegate {
  func tableViewDeleteRow(at indexPath: IndexPath) {
    if let objectId = dataSource.itemIdentifier(for: indexPath),
       let restaurant = try? context?.existingObject(with: objectId) {
      context?.delete(restaurant)
      
      do {
        try context?.save()
      } catch {
        fatalError()
      }
      
      NotificationCenter.default.post(name: .init("tableViewDidDeleteRows"), object: nil)
    }
  }
}
