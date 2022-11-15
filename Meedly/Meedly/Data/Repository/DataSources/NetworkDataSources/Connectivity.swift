//
//  Reachability.swift
//  Meedly
//
//  Created by Illia Poliakov on 19.10.22.
//

import Foundation
import Alamofire

class Connectivity {
  class func isConnectedToInternet() -> Bool {
    return NetworkReachabilityManager()?.isReachable ?? false
  }
}
