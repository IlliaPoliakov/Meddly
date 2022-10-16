//
//  ProvideTableViewDiffableDataSourceUseCase.swift
//  Meedly
//
//  Created by Illia Poliakov on 16.10.22.
//

import Foundation
import UIKit

//i dont know how to make it less dependent

class ProvideTableViewDiffableDataSourceUseCase: NSObject, UITableViewDataSource {
  
  // -MARK: - Dependencies -
  
  private var getGroupsUseCase: GetGroupsUseCase
  var tableView: UITableView
  var groups: [Group]?
  
  init(getGroupsUseCase: GetGroupsUseCase, tableView: UITableView) {
    self.getGroupsUseCase = getGroupsUseCase
    self.tableView = tableView
  }
  
  
  lazy var dataSource: UITableViewDiffableDataSource<String, Feed> = {
    let dataSource = UITableViewDiffableDataSource<String, Feed>(tableView: tableView) {
      tableView, _, model in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainVCCustomCell") as?
              MainTVCConvinientCell
      else {
        fatalError("Can't deque custom cell for main VC.")
      }
      cell.updateData(withFeed: model)
      
      return cell
    }
    
    return dataSource
  }()
  
  func configureInitialDiffableSnapshot(){
    var snapShot = NSDiffableDataSourceSnapshot<String, Feed>()
    groups = getGroupsUseCase.execute() // MB IN ASYNC
    snapShot.appendSections(["Today Feeds"])
    snapShot.appendSections((groups?.map({ $0.title! }))!) //boolshet
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    <#code#>
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    <#code#>
  }
  

  
  
}
