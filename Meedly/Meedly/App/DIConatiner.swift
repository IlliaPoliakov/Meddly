//
//  DIConatiner.swift
//  Meedly
//
//  Created by Illia Poliakov on 25.10.22.
//

import Foundation
import Swinject

class DependencyInjectionContainer {
  public static var shared : Container = Container()
  
  public static func initialize(){
    DependencyInjectionContainer.shared.register(DataBaseDataSource.self) { _ in DataBaseDataSource()}
    DependencyInjectionContainer.shared.register(NetworkDataSource.self) { _ in NetworkDataSource()}
    
    DependencyInjectionContainer.shared.register(CoreDataStack.self) { _ in CoreDataStack.shared }
    
    DependencyInjectionContainer.shared.register(MainTableView.self) { _ in MainTableView(tableView: UITableView(), groups: nil) }
    
    DependencyInjectionContainer.shared
      .register(FeedRepository.self) { resolver in
        FeedRepositoryImpl(localDataSource:
                            resolver.resolve(DataBaseDataSource.self)!,
                           remoteDataSource:
                            resolver.resolve(NetworkDataSource.self)!)
      }
    
    DependencyInjectionContainer.shared.register(GetFeedGroupsUseCase.self) { resolver in
      GetFeedGroupsUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(SaveNewGroupUseCase.self) { resolver in
      SaveNewGroupUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(SaveNewFeedUseCase.self) { resolver in
      SaveNewFeedUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(MarkAsReadedUseCase.self) { resolver in
      MarkAsReadedUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
  }
}

