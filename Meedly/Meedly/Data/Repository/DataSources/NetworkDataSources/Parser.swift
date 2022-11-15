//
//  Parser.swift
//  Meedly
//
//  Created by Illia Poliakov on 13.11.22.
//

import Foundation
import Combine

enum Errors: Error {
  case parseError
}

//
//class Parser: Publisher {
//  
//  typealias Output = FeedGroup
//  typealias Failure = Errors
//  
//  func receive<S>(subscriber: S) where S : Subscriber, Errors == S.Failure, FeedGroup == S.Input {
//    <#code#>
//  }
//  
//}
