//
//  Router.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.11.22.
//

import Foundation
import UIKit


final class Router {

  static var shared: Router = Router()
  
  
  // -MARK: - Properties -
  
  var navigationConrtoller: UINavigationController = UINavigationController()
  
  lazy var mainViewController: MainViewController = {
    let presenter: MainPresenter = MainPresenter()
    let viewController: MainViewController = MainViewController(presenter)
    
    presenter.assignViewController(viewController)
    
    return viewController
  }()
  
  lazy var addFeedViewController: AddFeedViewController = {
    let presenter: AddFeedPresenter = AddFeedPresenter()
    let viewController: AddFeedViewController = AddFeedViewController(presenter)
    
    presenter.assignViewController(viewController)
    
    return viewController
  }()
  
  weak var sideBarViewController: SideBarViewController? =
  AppDelegate.DIContainer.resolve(SideBarViewController.self)
  weak var descriptionViewController: DescriptionViewController? =
  AppDelegate.DIContainer.resolve(DescriptionViewController.self)
  
  
  // -MARK: - Funcs -
  
  func initialize(){
    navigationConrtoller.isToolbarHidden = false
    navigationConrtoller.isNavigationBarHidden = false
    
    navigationConrtoller.pushViewController(mainViewController, animated: true)
  }

  func presentAddFeedViewControole() {
    self.navigationConrtoller.pushViewController(addFeedViewController, animated: true)
  }
  
  func presentWarningAlert(withTitle title: String, withBody body: String) {
    let alert = UIAlertController(title: title,
                                  message: body,
                                  preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Ok", style: .default)
    
    alert.addAction(okAction)
    
    self.navigationConrtoller.present(alert, animated: true)
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
    
    self.navigationConrtoller.present(alert, animated: true, completion: nil)
  }
  
  func closeViewController(_ viewController: UIViewController) {
    viewController.navigationController?.popViewController(animated: true)
//    viewController.dismiss(animated: true, completion: nil)
  }
  
}
