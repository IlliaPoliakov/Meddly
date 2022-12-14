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
    
    // -MARK: - Data -
    
    DependencyInjectionContainer.shared.register(CoreDataStack.self) { _ in CoreDataStack.shared }
    
    DependencyInjectionContainer.shared.register(DataBaseDataSource.self) { _ in DataBaseDataSource()}
    DependencyInjectionContainer.shared.register(NetworkDataSource.self) { _ in NetworkDataSource()}
    
    // -MARK: - Repositories -
    
    DependencyInjectionContainer.shared
      .register(FeedRepository.self) { resolver in
        FeedRepositoryImpl(localDataSource:
                            resolver.resolve(DataBaseDataSource.self)!,
                           remoteDataSource:
                            resolver.resolve(NetworkDataSource.self)!)
      }
    
    // -MARK: - UseCases -
    
    DependencyInjectionContainer.shared.register(SaveNewFeedUseCase.self) { resolver in
      SaveNewFeedUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(MarkAsReadedUseCase.self) { resolver in
      MarkAsReadedUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(DeleteFeedUseCase.self) { resolver in
      DeleteFeedUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(DeleteGroupUseCase.self) { resolver in
      DeleteGroupUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(MarkAsReadedOldUseCase.self) { resolver in
      MarkAsReadedOldUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
  }
}

