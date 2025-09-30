//
//  ErrorHelper.swift
//  Wlif
//
//  Created by OSX on 02/07/2025.
//

import Foundation

class ErrorHelper {
    static func makeError(_ message: String) -> NSError {
        return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
