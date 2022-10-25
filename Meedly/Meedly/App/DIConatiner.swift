//
//  DIConatiner.swift
//  Meedly
//
//  Created by Illia Poliakov on 25.10.22.
//

import Foundation
import Swinject

class XDIContainer {
  public static var shared : Container = Container()
  
  public static func initialize(){
    XDIContainer.shared.register(LocalDataSource.self) { _ in DataBaseDataSource() }
    XDIContainer.shared.register(RemoteDataSource.self) { _ in NetworkDataSource() }
    XDIContainer.shared.register(CoreDataStack.self) { _ in CoreDataStack.shared }
    XDIContainer.shared.register(FeedRepository.self) { resolver in
      FeedRepositoryImpl(localDataSource: resolver.resolve(LocalDataSource.self)!,
                         remoteDataSource: resolver.resolve(RemoteDataSource.self)!)
    }
    XDIContainer.shared.register(GetFeedGroupsUseCase.self) { resolver in
      GetFeedGroupsUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    XDIContainer.shared.register(SaveNewGroupUseCase.self) { resolver in
      SaveNewGroupUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    XDIContainer.shared.register(SaveNewFeedUseCase.self) { resolver in
      SaveNewFeedUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    
  }
}

