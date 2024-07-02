//
//  UITestingHelper.swift
//  FetchCodingChallenge
//
//  Created by Donovan Smith on 7/2/24.
//
#if DEBUG
import Foundation

struct UITestingHelper {
    static var isUITesting: Bool {
        return ProcessInfo.processInfo.arguments.contains("-ui-testing")
    }
    
    static var isNetworkingSuccess: Bool {
        return ProcessInfo.processInfo.environment["-networking-success"] == "1"
    }
}



#endif
