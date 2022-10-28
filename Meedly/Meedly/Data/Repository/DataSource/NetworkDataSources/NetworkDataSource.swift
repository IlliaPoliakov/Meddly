//
//  RemoteDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation
import Alamofire

class NetworkDataSource: RemoteDataSource {
  
  // -MARK: - Properties -
  
  var dataTask: URLSessionDataTask?
  private lazy var session: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.waitsForConnectivity = true
    return URLSession(configuration: configuration,
                      delegate: nil, delegateQueue: nil)
  }()
  
  // -MARK: - Functions -
  
  func downloadData(withUrl url: URL, _ completion: @escaping (Data?, String?) -> Void) {
    
    let request = try? URLRequest(url: url, method: .get)
    
    self.dataTask = session.dataTask(with: request!) { data, response, error in
      
      guard let data = data, error == nil,
            (200..<300).contains((response as? HTTPURLResponse)!.statusCode)
      else {
        DispatchQueue.main.async {
          completion(nil, error?.localizedDescription)
        }
        return
      }
      
      DispatchQueue.main.async {
        completion(data, nil)
      }
    }
    
    dataTask?.resume()
  }
}
