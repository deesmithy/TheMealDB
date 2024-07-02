//
//  MockMealsService.swift
//  FetchCodingChallengeTests
//
//  Created by Donovan Smith on 7/2/24.
//
#if DEBUG
import Foundation

class MockMealsService: MealsService {
    
    init(networkSucceeds: Bool = UITestingHelper.isNetworkingSuccess) {
        self.networkSucceeds = networkSucceeds
    }
    
    var networkSucceeds: Bool
    
    func getMeals(for category: MealCategory) async -> [Meal] {
        if networkSucceeds {
            guard let url = Bundle.main.url(forResource: "Meals", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                return []
            }
            let meals = MockMealsService.mealsFromJSONData(data: data)
            return meals
        }
        else {
            return []
        }
    }
    
    
    func getMealDetails(mealId: String) async -> MealDetails? {
       return nil // I am not writing a full test suite, so I am not going to finish the mock fully.
    }
    
    
    static func mealsFromJSONData(data: Data) -> [Meal] {
        let decoder = JSONDecoder()
        do {
            let meals = try decoder.decode([Meal].self, from: data)
            return meals
        } catch {
            print("Error decoding meals: \(error)")
            return []
        }
    }
}


#endif

