//
//  MealsService.swift
//  FetchCodingChallenge
//
//  Created by Donovan Smith on 7/1/24.
//

import Foundation
import OSLog

protocol MealsService {
    func getMeals(for category: MealCategory) async -> [Meal]
    func getMealDetails(mealId: String) async -> MealDetails?
    
}

class MealsServiceImpl: MealsService {
    static let logger = Logger()
    
    ///This method fetches the meals for a given category. It returns an empty array if there is an error
    func getMeals(for category: MealCategory) async -> [Meal] {
        if let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=\(category.rawValue)") {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(MealsResponse.self, from: data)
                return response.meals
            } catch {
                //This should probably show an error to the user or otherwise handle the error better, but this is good enough for now 
                MealsServiceImpl.logger.error("Error in getMeals\(error.localizedDescription)")
                return []
            }
        }
        else { return [] }
    }
    
    ///This method finds the MealDetails for a given meal id. It returns nil if there is an error
    func getMealDetails(mealId: String) async -> MealDetails? {
        if let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealId)") {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(MealDetailsResponse.self, from: data)
                return response.meals.first
            } catch {
                MealsServiceImpl.logger.error("Error in getMealDetails: \(error.localizedDescription)")
                return nil
            }
        }
        else { return nil }
    }
    
    
    
}

