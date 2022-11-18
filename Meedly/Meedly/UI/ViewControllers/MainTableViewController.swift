//
//  MainTableViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 13.10.22.
//

import UIKit

enum UpdateState {
  case initialUpdate
  case regularUpdate
  case localUpdate
}

class MainTableViewController: UITableViewController {
  
  // MARK: - IBOutlets -
  
  @IBOutlet weak var presentationStyleButton: UIButton!
  @IBOutlet weak var markViewedButton: UIButton!
  
  
  // -MARK: - Properties -
  
  lazy var mainTableView: MainTableView = AppDelegate.DIContainer.resolve(MainTableView.self)!
  var updateState: UpdateState = .initialUpdate

  
  // -MARK: - Dependencies -
  
  private let getFeedGroupsUseCase: GetFeedGroupsUseCase =
  AppDelegate.DIContainer.resolve(GetFeedGroupsUseCase.self)!
  private let markAsReadedUseCase: MarkAsReadedUseCase =
  AppDelegate.DIContainer.resolve(MarkAsReadedUseCase.self)!
  private let markAsReadedOldUseCase: MarkAsReadedOldUseCase =
  AppDelegate.DIContainer.resolve(MarkAsReadedOldUseCase.self)!
  
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setTableView()
  
    updateState = .initialUpdate
    
    setSortButton()
    
    setPresentationStyleButton()
    
    setMarkAsReadButton()
    
    updateGroups(updateState: .initialUpdate) { [weak self] newGroups in
      self?.mainTableView.groups = newGroups
      self?.mainTableView.configureInitialSnapshot(withGroups: newGroups)
    }
  }
  
  //for commit
  
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "showAddVC":
      guard let destinaitonVC = segue.destination as? AddFeedViewController
      else {
        return
      }
      
      destinaitonVC.groups = mainTableView.groups
      
    case "descriptionSegueID" :
      guard let destinaitonVC = segue.destination as? ItemDescriptinViewConrtoller
      else {
        return
      }
      
      let selectedIndex = tableView.indexPathForSelectedRow
      let feedItem: FeedItem
      
      if mainTableView.presentationType == "Show All" {
        feedItem = mainTableView.groups![selectedIndex!.section].items![selectedIndex!.row]
        destinaitonVC.item = feedItem
        mainTableView.groups![selectedIndex!.section].items![selectedIndex!.row].isViewed = true
      }
      else {
        feedItem = mainTableView.allItems![selectedIndex!.row]
        destinaitonVC.item = feedItem
        mainTableView.allItems![selectedIndex!.row].isViewed = true
      }
      
      tableView.cellForRow(at: selectedIndex!)?.contentView.alpha = 0.5
      markAsReadedUseCase.execute(forFeedItem: feedItem)
      
      
    case "itemDescriptionWIthoutImageId":
      guard let destinaitonVC = segue.destination as? ItemDescriptinViewConrtollerWithoutImage
      else {
        return
      }
      
      let selectedIndex = tableView.indexPathForSelectedRow
      let feedItem: FeedItem
      
      if mainTableView.presentationType == "Show All" {
        feedItem = mainTableView.groups![selectedIndex!.section].items![selectedIndex!.row]
        destinaitonVC.item = feedItem
        
        mainTableView.groups![selectedIndex!.section].items![selectedIndex!.row].isViewed = true
      }
      else {
        feedItem = mainTableView.allItems![selectedIndex!.row]
        destinaitonVC.item = feedItem

        mainTableView.allItems![selectedIndex!.row].isViewed = true
      }
      
      tableView.cellForRow(at: selectedIndex!)?.contentView.alpha = 0.5
      markAsReadedUseCase.execute(forFeedItem: feedItem)
      
    case "id":
      guard let destinaitonVC = segue.destination as? SideBarViewController
      else {
        return
      }
      destinaitonVC.groups = self.mainTableView.groups!.filter { $0.feeds != nil &&
        !($0.feeds!.isEmpty) }
      destinaitonVC.mainTableViewController = self
      
    default:
      break
    }
  }
    
  @IBAction func unwind( _ segue: UIStoryboardSegue) {
    switch segue.identifier {
    case "unwindToMainFromAddVC":
      guard let previousVC = segue.source as? AddFeedViewController
      else {
        fatalError("Can't perform segue from AddVC")
      }
      
      let newAddGroups = previousVC.newGroups
      
      mainTableView.addNewGroups(withNewGroups: newAddGroups)
      
      updateGroups(updateState: .regularUpdate) { [weak self] newGroups in
        self?.mainTableView.groups = newGroups
        self?.mainTableView.configureInitialSnapshot(withGroups: newGroups)
        
        self?.updateState = .regularUpdate
      }
      
    default:
      break
    }
  }
  
  
  // MARK: - IBActions -
  
  @IBAction func update(_ sender: Any) {
    updateGroups(updateState: .regularUpdate) { [weak self] newGroups in
      self?.mainTableView.groups = newGroups
      self?.mainTableView.updatePresentation()
    }
  }
  
  
  // -MARK: - Supplementary Functions -
  
  func updateGroups(updateState state: UpdateState, _ completion: @escaping ([FeedGroup]?) -> Void){
    getFeedGroupsUseCase.execute(updateState: state) { loadedGroups, errorMessage in
      
      completion(loadedGroups)
   
      if errorMessage != nil {
        print("'\(errorMessage!)' occurred when downloading data.")
      }
    }
  }
  
  func setTableView() {
    mainTableView.tableView = tableView
    
    tableView.dataSource = mainTableView.dataSource
    tableView.delegate = mainTableView
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 600
  }
  
  func setSortButton() {
    let button: UIButton = UIButton()
    button.setImage(UIImage(systemName: "arrow.up.and.down.text.horizontal"), for: .normal)
    button.frame = CGRectMake(0, 0, 40, 40)
    button.tintColor = UIColor(named: "mainColor")
    let interaction = UIContextMenuInteraction(delegate: self)
    button.addInteraction(interaction)
    let barButtonItem: UIBarButtonItem = UIBarButtonItem()
    barButtonItem.customView = button

    self.toolbarItems!.remove(at: 3)
    self.toolbarItems!.insert(barButtonItem, at: 3)
  }
  
  func setPresentationStyleButton() {
    let menuClosure = {(action: UIAction) in
      if self.mainTableView.presentationState != action.title {
        self.mainTableView.presentationState = action.title
        self.mainTableView.tableView.reloadData()
      }
    }
    presentationStyleButton.menu =
    UIMenu(title: "Presentation Style:",
           children: [
            UIAction(title: "Text only", handler:
                      menuClosure),
            UIAction(title: "Convinient", state: .on, handler: menuClosure)
           ])
    presentationStyleButton.showsMenuAsPrimaryAction = true
    presentationStyleButton.changesSelectionAsPrimaryAction = true
  }
  
  func setMarkAsReadButton() {
    let menuClosure = {(action: UIAction) in
      self.markAsReadedOldUseCase.execute(forTimePeriod: action.title)
      
      self.updateGroups(updateState: .initialUpdate) { [weak self] newGroups in
        self?.mainTableView.groups = newGroups
        self?.mainTableView.configureInitialSnapshot(withGroups: newGroups)
      }
    }
    markViewedButton.menu =
    UIMenu(title: "Set as read news, older than:",
           children: [
            UIAction(title: "One Hour", handler: menuClosure),
            UIAction(title: "One Day", handler: menuClosure),
            UIAction(title: "One Week", handler: menuClosure),
            UIAction(title: "One Month", handler: menuClosure),
            UIAction(title: "Non", state: .on, handler: menuClosure),
           ])
    markViewedButton.showsMenuAsPrimaryAction = true
    markViewedButton.changesSelectionAsPrimaryAction = true
  }
}


// -MARK: - Extensions -

extension MainTableViewController: UIContextMenuInteractionDelegate {
  func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                              configurationForMenuAtLocation location: CGPoint)
  -> UIContextMenuConfiguration? {
    
    return UIContextMenuConfiguration(
      identifier: nil,
      previewProvider: nil,
      actionProvider: { _ in
        let all = self.makeAllAction()
        let newFirst = self.makeNewFirstAction()
        let oldFirst = self.makeOldFirstAction()
        let unreadOnly = self.makeUnreadOnlyAction()
        let byGroups = self.makeGroupsMenu()
        let children: [UIMenuElement] = [all, unreadOnly, newFirst, oldFirst, byGroups]
        return UIMenu(title: "Sort presentation:", children: children)
      })
  }
  
  func makeAllAction() -> UIAction {
    let allAttributes = UIMenuElement.Attributes()
    let allImage = UIImage(systemName: "books.vertical")!
      .withTintColor(UIColor(named: "mainColor")!, renderingMode: .alwaysOriginal)
    
    return UIAction(
      title: "Show All",
      image: allImage,
      identifier: nil,
      attributes: allAttributes) { _ in
        guard self.mainTableView.presentationType != "Show All"
        else {
          return
        }
        
        self.mainTableView.presentationType = "Show All"
        self.mainTableView.updatePresentation()
        
        self.title = "Show All"
      }
  }
  
  func makeUnreadOnlyAction() -> UIAction {
    let unreadAttributes = UIMenuElement.Attributes()
    let unreadImage = UIImage(systemName: "bookmark.slash")!
      .withTintColor(UIColor(named: "mainColor")!, renderingMode: .alwaysOriginal)
    
    return UIAction(
      title: "Unread Only",
      image: unreadImage,
      identifier: nil,
      attributes: unreadAttributes) { _ in
        guard self.mainTableView.presentationType != "Unread Only"
        else {
          return
        }
        
        self.mainTableView.presentationType = "Unread Only"
        self.mainTableView.updatePresentation()
        
        self.title = "Unread Only"
      }
  }
  
  func makeNewFirstAction() -> UIAction {
    let newFirstAttributes = UIMenuElement.Attributes()
    let newFirstImage = UIImage(systemName: "dock.arrow.down.rectangle")!
      .withTintColor(UIColor(named: "mainColor")!, renderingMode: .alwaysOriginal)
    
    return UIAction(
      title: "New First",
      image: newFirstImage,
      identifier: nil,
      attributes: newFirstAttributes) { _ in
        guard self.mainTableView.presentationType != "New First"
        else {
          return
        }
        
        self.mainTableView.presentationType = "New First"
        self.mainTableView.updatePresentation()
        
        self.title = "New First"
      }
  }
  
  func makeOldFirstAction() -> UIAction {
    let oldFirstAttributes = UIMenuElement.Attributes()
    let oldFirstImage = UIImage(systemName: "dock.arrow.up.rectangle")!
      .withTintColor(UIColor(named: "mainColor")!, renderingMode: .alwaysOriginal)
    
    return UIAction(
      title: "Old First",
      image: oldFirstImage,
      identifier: nil,
      attributes: oldFirstAttributes) { _ in
        guard self.mainTableView.presentationType != "Old First"
        else {
          return
        }
        
        self.mainTableView.presentationType = "Old First"
        self.mainTableView.updatePresentation()
        
        self.title = "Old First"
      }
  }
  
  func makeGroupsMenu() -> UIMenu {
    let groupsActions = mainTableView.groups!.enumerated().map { index, group in
      return UIAction(
        title: group.title,
        identifier: UIAction.Identifier("\(index + 1)"),
        handler: updatePresentationBySort(from:))
    }
    
    let oldFirstImage = UIImage(systemName: "folder.circle")!
      .withTintColor(UIColor(named: "mainColor")!, renderingMode: .alwaysOriginal)
    
    return UIMenu(
      title: "Group...",
      image: oldFirstImage,
      children: groupsActions)
  }
  
  func updatePresentationBySort(from action: UIAction) {
    guard let index = Int(action.identifier.rawValue)
    else {
      return
    }
    
    let chosenPresentationType = mainTableView.groups?[index - 1].title ?? "[no presentation type]"
    
    guard mainTableView.presentationType != chosenPresentationType
    else {
      return
    }
    
    self.mainTableView.presentationType = chosenPresentationType
    self.mainTableView.updatePresentation()
    
    self.title = chosenPresentationType
  }
  
}

// start combine
