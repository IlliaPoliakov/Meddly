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

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
