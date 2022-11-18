//
//  Constants.swift
//  Meedly
//
//  Created by Illia Poliakov on 15.11.22.
//

import Foundation

enum MeedlyError: LocalizedError, Identifiable {
  var id: String { localizedDescription }
  
  case noInternetConnection
  case requestFailed(forUrl: URL)
  case coreDataFetchFailure
  
  var errorDescription: String? {
    switch self {
    case .noInternetConnection: return "No Internet Connection."
    case .requestFailed(let url): return "\(url.absoluteString) is unreachable."
    default: break
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
