//
//  HomeViewViewModelTest.swift
//  FetchCodingChallengeTests
//
//  Created by Donovan Smith on 7/2/24.
//

import XCTest
@testable import FetchCodingChallenge

final class HomeViewViewModelTest: XCTestCase {

    var mealsService: MealsService!
    
    override func setUpWithError() throws {
        mealsService = MockMealsService(networkSucceeds: true)
    }

    override func tearDownWithError() throws {
        mealsService = nil
    }
    
    /// Test the HomeView ViewModel's getMeals() function correctly fetches and sets its meals property.
    func testFetchMeals() async {
        let viewModel = HomeView.ViewModel(mealsService: mealsService)
        XCTAssertEqual([FetchCodingChallenge.Meal](), viewModel.meals, "The HomeView ViewModel meals array should start out empty.")
        
        ///Wait for the viewModel.getMeals()
        let expectation = XCTestExpectation(description: "Waiting for the meals to load")
        var cancellable = viewModel.$meals.sink { meals in
            if !meals.isEmpty {
                expectation.fulfill()
            }
        }
        viewModel.getMeals()
        await fulfillment(of: [expectation], timeout: 3)
        XCTAssertEqual(MockMealsService.mealsFromJSONData(data: try Data(contentsOf: Bundle.main.url(forResource: "Meals", withExtension: "json")!)), viewModel.meals)
    }

}
