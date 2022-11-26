//
//  Constants.swift
//  Meedly
//
//  Created by Illia Poliakov on 15.11.22.
//

import Foundation
import UIKit


enum MeedlyError: Error {
  case noInternetConnection
  case requestFailed(forUrl: URL, withError: Error)
  
  case cachedDataIsEmpty
  case coreDataError
  
  case emptyFeed
  case empty
  
  case feedItemLinkIsUnreachable
  
  var errorDescription: String? {
    switch self {
    case .noInternetConnection:
      return "No Internet Connection."
      
    case .requestFailed(let url, let error):
      return "\(url.absoluteString) is unreachable. Error: \(error)"
      
    case .feedItemLinkIsUnreachable:
      return "Link For Current News Is Unreachable.."
      
    default: return String()
    }
  }
  
}


enum DefautlModelProperty: String {
  case title = "[no title provided]"
  case description = "[no description provided]"
  case link = "https://en.wikipedia.org/wiki/Bobby_Caldwell"
}
