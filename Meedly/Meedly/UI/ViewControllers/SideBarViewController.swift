//
//  SideBarViewController.swift
//  Meedly
//
//  Created by Illia Poliakov on 10.11.22.
//

import Foundation
import UIKit
import PINRemoteImage

enum Section {
  case main
}

class SideBarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  // -MARK: - Dependencies -
  
  private let deleteGroupUseCase: DeleteGroupUseCase =
  AppDelegate.DIContainer.resolve(DeleteGroupUseCase.self)!
  private let deleteFeedUseCase: DeleteFeedUseCase =
  AppDelegate.DIContainer.resolve(DeleteFeedUseCase.self)!
  
  // -MARK: - IBOutlets -
  
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var nickNameLavel: UILabel!
  @IBOutlet weak var collectionVIew: UICollectionView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var emailLabel: UILabel!
  
  
  // -MARK: - Properties -
  
  var groups: [FeedGroup] = [FeedGroup]()
  var sectionIndexPath: IndexPath? = nil
  var mainTableViewController: MainTableViewController = MainTableViewController()
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionVIew.dataSource = self
    collectionVIew.delegate = self
    
    avatarImage.layer.cornerRadius = avatarImage.bounds.height / 2
    avatarImage.layer.masksToBounds = true
    avatarImage.layer.borderWidth = 2.5
    avatarImage.layer.borderColor = UIColor(named: "mainColor")!.cgColor
    
    stackView.layer.cornerRadius = 10
    stackView.layer.borderWidth = 2.5
    stackView.layer.borderColor = UIColor(named: "mainColor")!.cgColor
  }
  
  
  // -MARK: - CollectionView -
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "SideBarCollectionViewCell",
      for: indexPath) as? SideBarCollectionViewCell
    else {
      return UICollectionViewCell()
    }

    cell.bind(withFeed: groups[indexPath.section].feeds![indexPath.row])
    return cell
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return groups.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return groups[section].feeds?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let feed = groups[indexPath.section].feeds![indexPath.row]
    let title: String = feed.title ?? "[no feed name]"
    let message: String = feed.imageUrl != nil ? ".\n.\n.\n" : ""
    let alert = UIAlertController(title: title,
                                  message: message, preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in 
      self.deleteFeedUseCase.execute(forFeed:
                                      feed)
      self.groups[indexPath.section].feeds!.remove(at: indexPath.row)
      if self.groups[indexPath.section].feeds!.isEmpty {
        self.groups.remove(at: indexPath.section)
      }
      collectionView.reloadData()
      
      self.mainTableViewController.updateGroups(updateState: .localUpdate) { newGroups in
        self.mainTableViewController.mainTableView.groups = newGroups
        self.mainTableViewController.mainTableView.updatePresentation()
      }
    }
    
    if message != "" {
      let imageView = UIImageView(frame: CGRect(x: 105, y: 50, width: 60, height: 60))
      imageView.layer.cornerRadius = 10
      imageView.pin_setImage(from: feed.imageUrl)
      alert.view.addSubview(imageView)
    }
    
    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    
    self.present(alert, animated: true, completion: nil)
  }
    
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath ) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      guard let headerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: "headerId",
        for: indexPath) as? CollectionReusableView
      else {
        return UICollectionReusableView()
      }
      
      headerView.groupNameTitle.text = groups[indexPath.section].title
      headerView.layer.borderColor = UIColor(named: "mainColor")!.cgColor
      headerView.layer.borderWidth = 2.5
      headerView.layer.cornerRadius = 10
      
      sectionIndexPath = indexPath
      
      let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                     action: #selector(self.handleTap(_:)))
      headerView.addGestureRecognizer(gestureRecognizer)
      
      return headerView
    default:
      assert(false, "Invalid element type")
    }
  }
  
  @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
    let group = groups[sectionIndexPath!.section]
    let title: String = group.title
    let alert = UIAlertController(title: title,
                                  message: nil,
                                  preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
      self.deleteGroupUseCase.execute(forGroup: group)
      self.groups.remove(at: self.sectionIndexPath!.section)
      self.collectionVIew.reloadData()
      
      self.mainTableViewController.updateGroups(updateState: .localUpdate) { newGroups in
        self.mainTableViewController.mainTableView.groups = newGroups
        self.mainTableViewController.mainTableView.updatePresentation()
      }
    }
    
    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    
    self.present(alert, animated: true, completion: nil)
  }
  
}
