//
//  Constants.swift
//  Meedly
//
//  Created by Illia Poliakov on 15.11.22.
//

import Foundation
import UIKit

enum PresentationType: String {
  case textOnly = "Text Only"
  case convinient = "Convinient"
}

enum MeedlyError: Error {
  case noInternetConnection
  case requestFailed(forUrl: URL)
  
  case cachedDataIsEmpty
  case coreDataError
  
  case emptyFeed
  case empty
  
  var errorDescription: String? {
    switch self {
    case .noInternetConnection: return "No Internet Connection."
    case .requestFailed(let url): return "\(url.absoluteString) is unreachable."
    default: return String()
    }
  }
  
}

enum SortType: String {
  case all = "All Feeds"
  case oldFirst = "Old First"
  case newFirst = "New First"
  case unreadOnly = "Unread Only"
}

enum ConstantSize: Double {
  case imageBorderWidth = 2.5
  case imageCornerRadius = 15
}

enum TimePeriod: TimeInterval {
  case oneHour = 3600
  case oneDay = 86400
  case twoDays = 172800
  case oneWeak = 604800
}

enum TimePeriodText: String {
  case oneHour = "One Hour"
  case oneDay = "One Day"
  case twoDays = "Two Days"
  case oneWeak = "One Weak"
}

enum DefautlModelProperty: String {
  case title = "[no title provided]"
  case description = "[no description provided]"
  case link = "https://en.wikipedia.org/wiki/Bobby_Caldwell"
}

enum AllertMessage: String {
  case groupExist = "Group With Given Title Already Exists!"
  case feedExist = "Feed With Given Link Already Exists!"
  case checkUrl = "Check Your Url!"
  case chooseGroup = "Group has not been selected!"
  case ops = "Ooops..."
  case errorOccured = " occured when getting data..."
}

let meedlyDateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.locale = Locale(identifier: "en_US_POSIX")
  formatter.dateFormat = "HH:mm E, d MMM y"
  return formatter
}()

enum CollectionViewSection {
  case main
}

enum DefaultGroup: String {
  case defaultGroup = "Default Group"
}

enum Colors {
  case mainColorClear
  case mainColorBackground
  
  func color() -> UIColor {
    switch self {
    case .mainColorClear:
      return UIColor(named: "mainColor")!
      
    case .mainColorBackground:
      return UIColor(named: "mainColor")!.withAlphaComponent(0.2)
    }
  }
}

enum ButtonImage {
  
}
