//
//  DIConatiner.swift
//  Meedly
//
//  Created by Illia Poliakov on 25.10.22.
//

import Foundation
import Swinject

class DependencyInjectionContainer {
  public static var shared: Container = Container()
  
  public static func initialize(){
    
    // -MARK: - Data -
    
    DependencyInjectionContainer.shared.register(CoreDataManager.self) { _ in
      CoreDataManager(modelName: "DataModelFeedly")
    }
    
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
    DependencyInjectionContainer.shared.register(GetItemsUseCase.self) { resolver in
      GetItemsUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(GetFeedsUseCase.self) { resolver in
      GetFeedsUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(DeleteFeedUseCase.self) { resolver in
      DeleteFeedUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(DeleteGroupUseCase.self) { resolver in
      DeleteGroupUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(MarkAsReadUseCase.self) { resolver in
      MarkAsReadUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(AdjustIsReadStateUseCase.self) { resolver in
      AdjustIsReadStateUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    DependencyInjectionContainer.shared.register(AdjustIsLikedStatetUseCase.self) { resolver in
      AdjustIsLikedStatetUseCase(repo: resolver.resolve(FeedRepository.self)!)
    }
    
    // -MARK: - Presenters -
    
    DependencyInjectionContainer.shared.register(MainPresenterProtocol.self) { _ in MainPresenter() }
    DependencyInjectionContainer.shared.register(AddFeedPresenterProtocol.self) { _ in
      AddFeedPresenter()
    }
    DependencyInjectionContainer.shared.register(DescriptionPresenterProtocol.self) { _ in
      DescriptionPresenter()
    }
    DependencyInjectionContainer.shared.register(SideBarPresenterProtocol.self) { _ in
      SideBarPresenter()
    }
  }
}

