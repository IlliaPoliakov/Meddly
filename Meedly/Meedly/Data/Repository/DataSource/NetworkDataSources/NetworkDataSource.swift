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
  
  var internetConnection: Bool = {
    NetworkReachabilityManager()?.isReachable ?? false
  }()
  
  
  // -MARK: - Funcs -
  
  func fetchData(fromUrl url: URL) -> Future<Result<Data?, MeedlyError>, Never> {
    guard internetConnection
    else {
      return Future { completion in
        completion(.success(.failure(.noInternetConnection)))
      }
    }
    
    return Future { completion in
      AF.request(url, method: .get)
        .validate { _, response, data in
          guard (200..<300).contains(response.statusCode),
                let data = data
          else {
            completion(.success(.failure(.requestFailed(forUrl: url))))
            return
          }
          
          completion(.success(data))
        }
    }
  }
}
