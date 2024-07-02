//
//  UITestingHelper.swift
//  FetchCodingChallenge
//
//  Created by Donovan Smith on 7/2/24.
//

#if DEBUG
import Foundation
///This helps determine if the app is running in a UI testing environment and allows for some configuration that is useful for testing. It is not used in the main app.
struct UITestingHelper {
    static var isUITesting: Bool {
        return ProcessInfo.processInfo.arguments.contains("-ui-testing")
    }
    
    static var isNetworkingSuccess: Bool {
        return ProcessInfo.processInfo.environment["-networking-success"] == "1"
    }
}



#endif
