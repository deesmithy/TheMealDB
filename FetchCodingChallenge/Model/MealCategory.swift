//
//  MealCategory.swift
//  FetchCodingChallenge
//
//  Created by Donovan Smith on 7/1/24.
//

import Foundation

///This is a meal category enum that is used to filter the meals that are fetched from the API. This was outside of the provided spec, but made the UX a little bit better to give them access to more meals.
enum MealCategory: String, CaseIterable {
    case beef = "Beef"
    case breakfast = "Breakfast"
    case chicken = "Chicken"
    case dessert = "Dessert"
    case goat = "Goat"
    case lamb = "Lamb"
    case miscellaneous = "Miscellaneous"
    case pasta = "Pasta"
    case pork = "Pork"
    case seafood = "Seafood"
    case side = "Side"
    case starter = "Starter"
    case vegan = "Vegan"
    case vegetarian = "Vegetarian"
}

