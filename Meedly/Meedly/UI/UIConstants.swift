//
//  UIConstants.swift
//  Meedly
//
//  Created by Illia Poliakov on 25.11.22.
//

import UIKit

enum PresentationType: String {
  case textOnly = "Text Only"
  case convinient = "Convinient"
}

enum SortType: String {
  case all = "All"
  case oldFirst = "Old First"
  case newFirst = "New First"
  case unreadOnly = "Unread Only"
  case liked = "Liked Only"
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
  
  func text() -> String{
    switch self {
    case .oneHour:
      return "One Hour"
    case .oneDay:
      return "One Day"
    case .twoDays:
      return "Two Days"
    case .oneWeak:
      return "One Weak"
    }
  }
}

enum AllertMessage: String {
  case groupExist = "Group With Given Title Already Exists!"
  case feedExist = "Feed With Given Link Already Exists!"
  case checkUrl = "Check Your Url!"
  case chooseGroup = "Group has not been selected!"
  case ops = "Ooops..."
  case errorOccured = " occured when getting data..."
}

let MeedlyDateFormatter: DateFormatter = {
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
