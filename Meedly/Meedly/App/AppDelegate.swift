//
//  AppDelegate.swift
//  Meedly
//
//  Created by Illia Poliakov on 12.10.22.
//

import UIKit
import CoreData
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  // -MARK: - Properties -
  
  public static let DIContainer = Container()
  
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    AppDelegate.DIContainer.register(LocalDataSource.self) { _ in DataBaseDataSource() }
    AppDelegate.DIContainer.register(RemoteDataSource.self) { _ in NetworkDataSource() }
    AppDelegate.DIContainer.register(CoreDataStack.self) { _ in CoreDataStack.shared }
    AppDelegate.DIContainer.register(FeedRepository.self) { resolver in
      FeedRepositoryImpl(localDataSource: resolver.resolve(LocalDataSource.self)!,
                         remoteDataSource: resolver.resolve(RemoteDataSource.self)!)
    }
    AppDelegate.DIContainer.register(GetFeedGroupsUseCase.self) { resolver in
      GetFeedGroupsUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    AppDelegate.DIContainer.register(SaveNewGroupUseCase.self) { resolver in
      SaveNewGroupUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    AppDelegate.DIContainer.register(SaveNewFeedUseCase.self) { resolver in
      SaveNewFeedUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    
    return true
  }
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    
  }
  
}

