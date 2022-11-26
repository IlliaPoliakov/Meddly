//
//  DescriptionPresenter.swift
//  Meedly
//
//  Created by Illia Poliakov on 23.11.22.
//

import UIKit

protocol DescriptionPresenterProtocol: UICollectionViewDelegate {
  func assignViewController(_ viewController: UIViewController)
  func visiteWebSiteButtonTupped()
}


final class DescriptionPresenter: NSObject, DescriptionPresenterProtocol {

  // -MARK: - Dependensies -
  
  private weak var viewController: DescriptionViewController?

  
  // -MARK: - Funcs -
  
  func assignViewController(_ viewController: UIViewController){
    self.viewController = (viewController as? DescriptionViewController)
  }
  
  func visiteWebSiteButtonTupped() {
    guard let url = self.viewController?.feedItem?.link
    else {
      AppDelegate.router.presentWarningAlert(
        withTitle: MeedlyError.feedItemLinkIsUnreachable.errorDescription!,
        withBody: "")
      return
    }
    UIApplication.shared.open(url)
  }

}
