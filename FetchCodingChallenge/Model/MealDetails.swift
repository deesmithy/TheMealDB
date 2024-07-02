//
//  MealDetails.swift
//  FetchCodingChallenge
//
//  Created by Donovan Smith on 7/1/24.
//

import Foundation

struct MealDetails: Codable {
    
    var id: String
    var name: String
    var drinkAlternate: String?
    var category: String?
    var area: String?
    var instructions: String?
    var thumbnailURL: String?
    var tags: String?
    var youtubeURL: String?
    
    /// A list of ingredients for the meal. This list is created by filtering out any empty strings from the provided ingredients
    var ingredients: [String] {
        return [ingredient1, ingredient2, ingredient3, ingredient4, ingredient5, ingredient6, ingredient7, ingredient8, ingredient9, ingredient10, ingredient11, ingredient12, ingredient13, ingredient14, ingredient15, ingredient16, ingredient17, ingredient18, ingredient19, ingredient20].compactMap { $0 }.filter { !$0.isEmpty }
    }
    
    /// A list of measures for the meal. This list is created by filtering out any empty strings from the provided measures
    var measures: [String] {
        return [measure1, measure2, measure3, measure4, measure5, measure6, measure7, measure8, measure9, measure10, measure11, measure12, measure13, measure14, measure15, measure16, measure17, measure18, measure19, measure20].compactMap { $0 }.filter { !$0.isEmpty }
    }
    
    ///The names of the properties in the JSON response are different from the names of the properties in the struct. This enum helps to map the JSON keys to the struct properties.
    private enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case drinkAlternate = "strDrinkAlternate"
        case category = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case thumbnailURL = "strMealThumb"
        case tags = "strTags"
        case youtubeURL = "strYoutube"
        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        case ingredient16 = "strIngredient16"
        case ingredient17 = "strIngredient17"
        case ingredient18 = "strIngredient18"
        case ingredient19 = "strIngredient19"
        case ingredient20 = "strIngredient20"
        case measure1 = "strMeasure1"
        case measure2 = "strMeasure2"
        case measure3 = "strMeasure3"
        case measure4 = "strMeasure4"
        case measure5 = "strMeasure5"
        case measure6 = "strMeasure6"
        case measure7 = "strMeasure7"
        case measure8 = "strMeasure8"
        case measure9 = "strMeasure9"
        case measure10 = "strMeasure10"
        case measure11 = "strMeasure11"
        case measure12 = "strMeasure12"
        case measure13 = "strMeasure13"
        case measure14 = "strMeasure14"
        case measure15 = "strMeasure15"
        case measure16 = "strMeasure16"
        case measure17 = "strMeasure17"
        case measure18 = "strMeasure18"
        case measure19 = "strMeasure19"
        case measure20 = "strMeasure20"
    }
    
    ///This initializer is used to decode the JSON response from the API. It replaces optional values with nil if they are nil. This assumes that the name and Id are never nil, and will fail if either is nil.
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        drinkAlternate = try container.decodeIfPresent(String.self, forKey: .drinkAlternate)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        area = try container.decodeIfPresent(String.self, forKey: .area)
        instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        thumbnailURL = try container.decodeIfPresent(String.self, forKey: .thumbnailURL)
        tags = try container.decodeIfPresent(String.self, forKey: .tags)
        youtubeURL = try container.decodeIfPresent(String.self, forKey: .youtubeURL)
        ingredient1 = try container.decodeIfPresent(String.self, forKey: .ingredient1)
        ingredient2 = try container.decodeIfPresent(String.self, forKey: .ingredient2)
        ingredient3 = try container.decodeIfPresent(String.self, forKey: .ingredient3)
        ingredient4 = try container.decodeIfPresent(String.self, forKey: .ingredient4)
        ingredient5 = try container.decodeIfPresent(String.self, forKey: .ingredient5)
        ingredient6 = try container.decodeIfPresent(String.self, forKey: .ingredient6)
        ingredient7 = try container.decodeIfPresent(String.self, forKey: .ingredient7)
        ingredient8 = try container.decodeIfPresent(String.self, forKey: .ingredient8)
        ingredient9 = try container.decodeIfPresent(String.self, forKey: .ingredient9)
        ingredient10 = try container.decodeIfPresent(String.self, forKey: .ingredient10)
        ingredient11 = try container.decodeIfPresent(String.self, forKey: .ingredient11)
        ingredient12 = try container.decodeIfPresent(String.self, forKey: .ingredient12)
        ingredient13 = try container.decodeIfPresent(String.self, forKey: .ingredient13)
        ingredient14 = try container.decodeIfPresent(String.self, forKey: .ingredient14)
        ingredient15 = try container.decodeIfPresent(String.self, forKey: .ingredient15)
        ingredient16 = try container.decodeIfPresent(String.self, forKey: .ingredient16)
        ingredient17 = try container.decodeIfPresent(String.self, forKey: .ingredient17)
        ingredient18 = try container.decodeIfPresent(String.self, forKey: .ingredient18)
        ingredient19 = try container.decodeIfPresent(String.self, forKey: .ingredient19)
        ingredient20 = try container.decodeIfPresent(String.self, forKey: .ingredient20)
        measure1 = try container.decodeIfPresent(String.self, forKey: .measure1)
        measure2 = try container.decodeIfPresent(String.self, forKey: .measure2)
        measure3 = try container.decodeIfPresent(String.self, forKey: .measure3)
        measure4 = try container.decodeIfPresent(String.self, forKey: .measure4)
        measure5 = try container.decodeIfPresent(String.self, forKey: .measure5)
        measure6 = try container.decodeIfPresent(String.self, forKey: .measure6)
        measure7 = try container.decodeIfPresent(String.self, forKey: .measure7)
        measure8 = try container.decodeIfPresent(String.self, forKey: .measure8)
        measure9 = try container.decodeIfPresent(String.self, forKey: .measure9)
        measure10 = try container.decodeIfPresent(String.self, forKey: .measure10)
        measure11 = try container.decodeIfPresent(String.self, forKey: .measure11)
        measure12 = try container.decodeIfPresent(String.self, forKey: .measure12)
        measure13 = try container.decodeIfPresent(String.self, forKey: .measure13)
        measure14 = try container.decodeIfPresent(String.self, forKey: .measure14)
        measure15 = try container.decodeIfPresent(String.self, forKey: .measure15)
        measure16 = try container.decodeIfPresent(String.self, forKey: .measure16)
        measure17 = try container.decodeIfPresent(String.self, forKey: .measure17)
        measure18 = try container.decodeIfPresent(String.self, forKey: .measure18)
        measure19 = try container.decodeIfPresent(String.self, forKey: .measure19)
        measure20 = try container.decodeIfPresent(String.self, forKey: .measure20)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(drinkAlternate, forKey: .drinkAlternate)
        try container.encode(category, forKey: .category)
        try container.encode(area, forKey: .area)
        try container.encode(instructions, forKey: .instructions)
        try container.encode(thumbnailURL, forKey: .thumbnailURL)
        try container.encode(tags, forKey: .tags)
        try container.encode(youtubeURL, forKey: .youtubeURL)
        try container.encode(ingredient1, forKey: .ingredient1)
        try container.encode(ingredient2, forKey: .ingredient2)
        try container.encode(ingredient3, forKey: .ingredient3)
        try container.encode(ingredient4, forKey: .ingredient4)
        try container.encode(ingredient5, forKey: .ingredient5)
        try container.encode(ingredient6, forKey: .ingredient6)
        try container.encode(ingredient7, forKey: .ingredient7)
        try container.encode(ingredient8, forKey: .ingredient8)
        try container.encode(ingredient9, forKey: .ingredient9)
        try container.encode(ingredient10, forKey: .ingredient10)
        try container.encode(ingredient11, forKey: .ingredient11)
        try container.encode(ingredient12, forKey: .ingredient12)
        try container.encode(ingredient13, forKey: .ingredient13)
        try container.encode(ingredient14, forKey: .ingredient14)
        try container.encode(ingredient15, forKey: .ingredient15)
        try container.encode(ingredient16, forKey: .ingredient16)
        try container.encode(ingredient17, forKey: .ingredient17)
        try container.encode(ingredient18, forKey: .ingredient18)
        try container.encode(ingredient19, forKey: .ingredient19)
        try container.encode(ingredient20, forKey: .ingredient20)
        try container.encode(measure1, forKey: .measure1)
        try container.encode(measure2, forKey: .measure2)
        try container.encode(measure3, forKey: .measure3)
        try container.encode(measure4, forKey: .measure4)
        try container.encode(measure5, forKey: .measure5)
        try container.encode(measure6, forKey: .measure6)
        try container.encode(measure7, forKey: .measure7)
        try container.encode(measure8, forKey: .measure8)
        try container.encode(measure9, forKey: .measure9)
        try container.encode(measure10, forKey: .measure10)
        try container.encode(measure11, forKey: .measure11)
        try container.encode(measure12, forKey: .measure12)
        try container.encode(measure13, forKey: .measure13)
        try container.encode(measure14, forKey: .measure14)
        try container.encode(measure15, forKey: .measure15)
        try container.encode(measure16, forKey: .measure16)
        try container.encode(measure17, forKey: .measure17)
        try container.encode(measure18, forKey: .measure18)
        try container.encode(measure19, forKey: .measure19)
        try container.encode(measure20, forKey: .measure20)
    }
    
    ///These properties are used to store the ingredients and measures for the meal. They are optional because the API response may not include all 20 ingredients and measures. They are private because the ingredients and measures are accessed through the calculated ingredients and measures properties.
    private var ingredient1: String?
    private var ingredient2: String?
    private var ingredient3: String?
    private var ingredient4: String?
    private var ingredient5: String?
    private var ingredient6: String?
    private var ingredient7: String?
    private var ingredient8: String?
    private var ingredient9: String?
    private var ingredient10: String?
    private var ingredient11: String?
    private var ingredient12: String?
    private var ingredient13: String?
    private var ingredient14: String?
    private var ingredient15: String?
    private var ingredient16: String?
    private var ingredient17: String?
    private var ingredient18: String?
    private var ingredient19: String?
    private var ingredient20: String?
    private var measure1: String?
    private var measure2: String?
    private var measure3: String?
    private var measure4: String?
    private var measure5: String?
    private var measure6: String?
    private var measure7: String?
    private var measure8: String?
    private var measure9: String?
    private var measure10: String?
    private var measure11: String?
    private var measure12: String?
    private var measure13: String?
    private var measure14: String?
    private var measure15: String?
    private var measure16: String?
    private var measure17: String?
    private var measure18: String?
    private var measure19: String?
    private var measure20: String?
    
    

}
