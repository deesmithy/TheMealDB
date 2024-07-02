//
//  HomeViewUITests.swift
//  FetchCodingChallengeUITests
//
//  Created by Donovan Smith on 7/2/24.
//

import XCTest
@testable import FetchCodingChallenge

final class HomeViewUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launchEnvironment = ["-networking-success":"1"]
        app.launch()
    }
    
    override func tearDown() {
        app = nil
    }
    
    //Tests that the HomeView shows the list of foods when the network successfully fetches the meals
    func testHomeViewShowsFoodsWhenNetworkSuccessful() {
        
        let mealList = app.descendants(matching: .any)["mealsList"]
        XCTAssertTrue(mealList.waitForExistence(timeout: 5), "The list of meals should be visible")
        
        let mealListItem = mealList.cells.firstMatch
        XCTAssertTrue(mealListItem.exists)
        
        mealListItem.tap()
        
        let mealDetailsView = app.descendants(matching: .any)["mealDetailsView"]
        XCTAssertTrue(mealDetailsView.exists)
    }
    
    //Tests that the HomeView properly shows the error when the network fails to fetch the meals
    func testHomeViewShowsErrorWhenNetworkFails() {
        app.terminate()
        app.launchEnvironment = ["-networking-success":"0"]
        app.launch()
        
        let mealList = app.descendants(matching: .any)["mealsList"]
        XCTAssertTrue(mealList.waitForExistence(timeout: 5), "The list of meals should be visible")
        
        let mealListItem = mealList.cells.firstMatch
        XCTAssertFalse(mealListItem.exists)
        
        let errorView = app.descendants(matching: .any)["ErrorView"]
        XCTAssertTrue(errorView.exists)
        
        
    }
}
