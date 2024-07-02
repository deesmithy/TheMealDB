//
//  Extension.swift
//  FetchCodingChallenge
//
//  Created by Donovan Smith on 7/1/24.
//

import Foundation


extension String {
    /// A string extension that removes all whitespace from a string. 
    func removingWhiteSpaces() -> String {
        return String(self.filter { !" \n\t\r".contains($0) })
    }
}
