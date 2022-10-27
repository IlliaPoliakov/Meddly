//
//  RemoteDataSource.swift
//  Meedly
//
//  Created by Illia Poliakov on 14.10.22.
//

import Foundation
import Alamofire

class NetworkDataSource: NSObject, RemoteDataSource {
  
  private lazy var session: URLSession = {
    let configuration = URLSessionConfiguration.default
    //      configuration.waitsForConnectivity = true
    return URLSession(configuration: configuration,
                      delegate: self, delegateQueue: nil)
  }()
  
  func loadData(withGroups groups: [FeedGroupEntity]?) -> [FeedGroupEntity]? {
    guard groups != nil
    else {
      return nil
    }
    
    for group in groups! {
      
      if group.feeds != nil {
        for feed in group.feeds! {
          print(feed.title!)
        }
      }
    }
    
    return nil // tmp
  }
  
}


extension NetworkDataSource: URLSessionDataDelegate {
  
//  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
//                  completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
//    guard let response = response as? HTTPURLResponse,
//          (200...299).contains(response.statusCode),
//          let mimeType = response.mimeType,
//          mimeType == "text/html" else {
//      completionHandler(.cancel)
//      return
//    }
//    completionHandler(.allow)
//  }
//  
//  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//    self.receivedData?.append(data)
//  }
//  
//  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//    DispatchQueue.main.async {
//      self.loadButton.isEnabled = true
//      if let error = error {
//        handleClientError(error)
//      } else if let receivedData = self.receivedData,
//                let string = String(data: receivedData, encoding: .utf8) {
//        self.webView.loadHTMLString(string, baseURL: task.currentRequest?.url)
//      }
//    }
//  }
}
