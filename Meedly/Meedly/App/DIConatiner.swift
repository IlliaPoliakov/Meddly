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
    DependencyInjectionContainer.shared.register(LocalDataSource.self) { _ in DataBaseDataSource() }
    DependencyInjectionContainer.shared.register(RemoteDataSource.self) { _ in NetworkDataSource() }
    
    DependencyInjectionContainer.shared.register(CoreDataStack.self) { _ in CoreDataStack.shared }
    
    DependencyInjectionContainer.shared.register(FeedRepository.self) { _ in FeedRepositoryImpl.shared }
    
    DependencyInjectionContainer.shared.register(GetFeedGroupsUseCase.self) { resolver in
      GetFeedGroupsUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(SaveNewGroupUseCase.self) { resolver in
      SaveNewGroupUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(SaveNewFeedUseCase.self) { resolver in
      SaveNewFeedUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
  }
}

