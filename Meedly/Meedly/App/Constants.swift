//
//  Constants.swift
//  Meedly
//
//  Created by Illia Poliakov on 15.11.22.
//

import Foundation

enum MeedlyError: Error {
  case noInternetConnection
  case requestFailed(forUrl: URL)
  
  case cachedDataIsEmpty
  case coreDataError
  
  case empty
  
  var errorDescription: String? {
    switch self {
    case .noInternetConnection: return "No Internet Connection."
    case .requestFailed(let url): return "\(url.absoluteString) is unreachable."
    default: return String()
    }
  }
  
}

enum ConstantSize: Double {
  case imageBorderWidth = 2.5
}

enum TimePeriod: TimeInterval {
  case oneHour = 3600
  case oneDay = 86400
  case twoDays = 172800
  case oneWeak = 604800
}

enum DefautlModelProperty: String {
  case title = "[no title provided]"
  case description = "[no description provided]"
  case link = "https://en.wikipedia.org/wiki/Bobby_Caldwell" /*"https://rt.pornhub.com/"*/
}
