//
//  RemoteDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation
import Alamofire
import Combine

class NetworkDataSource {
  
  // -MARK: - Properties -
  
  var internetConnection = {
    NetworkReachabilityManager()?.isReachable ?? false
  }

  func fetchItems(fromUrls url: URL) -> Future<Data, Never> {
    
    return Future<Data, Never> { promise in
      let data = AF.request(url, method: .get)
        .validate()
    }
    
//    return AF.request(url, method: .get)
//      .validate()
//      .publishUnserialized()
//      .map { reponse in
//        reponse.mapError { error in
//          return MeedlyErrors
//        }
//      }
//      .receive(on: DispatchQueue.main)
//      .eraseToAnyPublisher()
//  }
}
