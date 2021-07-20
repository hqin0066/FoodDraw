//
//  ListViewUITableDataSource.swift
//  ListViewUITableDataSource
//
//  Created by Hao Qin on 7/19/21.
//

import UIKit
import CoreData

protocol ListViewUITableDataSourceDelegate: AnyObject {
  func tableViewDeleteRow(at indexPath: IndexPath)
}

class ListViewUITableDataSource: UITableViewDiffableDataSource<String, NSManagedObjectID> {
  
  weak var delegate: ListViewUITableDataSourceDelegate?
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      delegate?.tableViewDeleteRow(at: indexPath)
    }
  }
}
