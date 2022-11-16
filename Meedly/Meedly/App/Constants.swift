//
//  Constants.swift
//  Meedly
//
//  Created by Illia Poliakov on 15.11.22.
//

import Foundation

enum MeedlyErrors: LocalizedError, Identifiable {
  var id: String { localizedDescription }
  
  case noInternetConnectino
  case requestFailed(URL)
  
  var errorDescription: String? {
    switch self {
    case .noInternetConnectino: return "No Internet Connection."
    case .requestFailed(let url): return "\(url.absoluteString) is unreachable."
    }
  }
}

enum ConstantSizes: Double {
  case imageBorderWidth = 2.5
}

enum TimeIntervals: String {
  case oneHour = "One Hour"
  case twelveHours = "Twelve Hours"
  case oneDay = "One Day"
  case twoDays = "Two Days"
  case oneWeak = "One Weak"
  case oneMonth = "One Month"
}
