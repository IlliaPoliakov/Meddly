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
    
    let semaphore = DispatchSemaphore(value: 0)
    
    var responseData: Data? = nil
    var responseError: Error? = nil

    
    AF.request(url, method: .get).validate().responseData { data in
      switch data.result {
      case .success(let value):
        responseData = value

      case .failure(let error):
        responseError = error

      }
      semaphore.signal()
    }
    
    semaphore.wait()
    
    guard let data = responseData
    else {
      return .failure(.requestFailed(forUrl: url, withError: responseError!))
    }
    
    return .success(data)
  }
}
