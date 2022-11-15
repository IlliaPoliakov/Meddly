//
//  RemoteDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation
import Combine
import Alamofire

struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var status: String
    var message: String
}

class NetworkDataSource {
  
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
      
      completion(data, nil)
    }
    
    dataTask?.resume()
  }
  
  func downloadData(withUrl url: URL) -> Future<Data, Never> {
    return Future { promise in
      
    }
  }

//  func downloadData(fromUrl url: URL)
//  -> AnPuyblisher<DataResponse<Data, NetworkError>, Never> {
//    
//    return AF.request(url, method: .get)
//      .validate(statusCode: 200..<300)
//      .publishData()
//      .map { response in
//        response.mapError { error in
//          let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self,
//                                                                               from: $0)}
//          return NetworkError(initialError: error, backendError: backendError)
//        }
//      }
//      .receive(on: DispatchQueue.global(qos: .userInitiated))
//      .eraseToAnyPublisher()
//  }
  
  
}
