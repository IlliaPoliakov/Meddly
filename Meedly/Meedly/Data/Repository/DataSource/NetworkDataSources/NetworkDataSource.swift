//
//  RemoteDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation
import Alamofire
import Combine

final class NetworkDataSource {
  
  // -MARK: - Properties -
  
  private var internetConnection: Bool {
    get {
      NetworkReachabilityManager()?.isReachable ?? false
    }
  }
  
  
  // -MARK: - Funcs -
  
  func fetchData(fromUrl url: URL) -> Result<Data, MeedlyError> {
    guard internetConnection
    else {
      return .failure(.noInternetConnection)
    }
    
    let request = AF.request(url, method: .get).validate()
    
    guard let data = request.data
    else {
      return .failure(.requestFailed(forUrl: url))
    }
    
    return .success(data)
  }
}
