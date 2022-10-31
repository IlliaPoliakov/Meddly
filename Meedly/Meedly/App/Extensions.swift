//
//  Extensions.swift
//  Meedly
//
//  Created by Illia Poliakov on 31.10.22.
//

import Foundation

extension Array where Element: Hashable {
  func difference(from other: [Element]) -> [Element]? {
    let thisSet = Set(self)
    let otherSet = Set(other)
    let diff = Array(thisSet.symmetricDifference(otherSet))
    return diff.isEmpty ? nil : diff
  }
}
