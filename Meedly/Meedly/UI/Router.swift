//
//  Router.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.11.22.
//

import Foundation
import UIKit

protocol RouterProtocol {
  var navigationController: UINavigationController { get }
  var mainViewController: UIViewController { get }
  var addFeedViewController: UIViewController { get }
  var descriptionViewController: UIViewController { get }
  var sideBarViewController: UIViewController { get }
}


final class Router: RouterProtocol {

  static var shared: Router = Router()
  
  // -MARK: - Properties -
  
  var navigationController: UINavigationController = {
    var navigationConrtoller = UINavigationController()
    navigationConrtoller.isToolbarHidden = false
    navigationConrtoller.isNavigationBarHidden = false
    
    navigationConrtoller.navigationBar.tintColor = Colors.color(.mainColorClear)()
    
    return navigationConrtoller
  }()
  
  lazy var mainViewController: UIViewController = {
    let presenter: MainPresenterProtocol =
    AppDelegate.DIContainer.resolve(MainPresenterProtocol.self)!
    
    let viewController: MainViewController = MainViewController(presenter)
    
    presenter.assignViewController(viewController)
    
    return viewController
  }()
  
  lazy var addFeedViewController: UIViewController = {
    let presenter: AddFeedPresenterProtocol =
    AppDelegate.DIContainer.resolve(AddFeedPresenterProtocol.self)!
    
    let viewController: UIViewController = AddFeedViewController(presenter)
    viewController.modalPresentationStyle = .pageSheet
    
    presenter.assignViewController(viewController)
    
    return viewController
  }()
  
  lazy var sideBarViewController: UIViewController = {
    let presenter: SideBarPresenterProtocol =
    AppDelegate.DIContainer.resolve(SideBarPresenterProtocol.self)!
    
    let viewController: UIViewController = SideBarViewController(presenter)
    
    presenter.assignViewController(viewController)
    
    return viewController
  }()
  
  lazy var descriptionViewController: UIViewController = {
    let presenter: DescriptionPresenterProtocol =
    AppDelegate.DIContainer.resolve(DescriptionPresenterProtocol.self)!
    
    let viewController: DescriptionViewController = DescriptionViewController(presenter)
    viewController.modalPresentationStyle = .pageSheet
    
    presenter.assignViewController(viewController)
    
    return viewController
  }()
  
  
  // -MARK: - Funcs -
  
  func initialize(){
    navigationController.pushViewController(mainViewController, animated: true)
  }
  
  func presentAddFeedViewControole() {
    navigationController.present(addFeedViewController, animated: true)
  }
  
  func presentDescriptionViewControole(forFeedItem feedItem: FeedItem) {
    guard let viewController = descriptionViewController as? DescriptionViewController
    else {
      return
    }
    navigationController.present(viewController, animated: true)
    viewController.feedItem = feedItem
  }
  
  func closeAddFeedViewController(){
    addFeedViewController.dismiss(animated: true)
    guard let viewController = mainViewController as? MainViewController
    else {
      return
    }
    
    viewController.presenter.intialize()
  }
  
  func presentWarningAlert(withTitle title: String, withBody body: String) {
    let alert = UIAlertController(title: title,
                                  message: body,
                                  preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Ok", style: .default)
    
    alert.addAction(okAction)
    
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

    if var topController = keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }

      topController.present(alert, animated: true)
    }
    
  }
  
  func presentAddGroupAlert(_ completion: @escaping (String?) -> Void) {
    let alert = UIAlertController(title: "New Group",
                                  message: "Enter a Group Name:",
                                  preferredStyle: .alert)
    
    alert.addTextField { _ in }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default)
    
    let addAction = UIAlertAction(title: "Add", style: .cancel) { [weak alert] _ in
      guard let groupName = alert!.textFields![0].text,
            groupName != ""
      else {
        completion(nil)
        return
      }
      
      completion(groupName)
    }
    
    alert.addAction(addAction)
    alert.addAction(cancelAction)
    
    self.addFeedViewController.present(alert, animated: true, completion: nil)
  }
  
}
