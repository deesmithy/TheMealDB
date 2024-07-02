//
//  Meal.swift
//  FetchCodingChallenge
//
//  Created by Donovan Smith on 7/1/24.
//

import Foundation

struct Meal: Codable {
    let name: String
    let thumbnailURL: String
    let id: String
    
    
    
    init(name: String, thumbnailURL: String, id: String) {
        self.name = name
        self.thumbnailURL = thumbnailURL
        self.id = id
    }
    
    ///The names of the properties in the JSON response are different from the names of the properties in the struct. This enum helps to map the JSON keys to the struct properties.
    private enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case thumbnail = "strMealThumb"
        case id = "idMeal"
    }
    
    ///This initializer is used to decode the JSON response from the API. It replaces optional values with empty strings if they are nil.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = (try? container.decodeIfPresent(String.self, forKey: .name)) ?? ""
        thumbnailURL = (try? container.decodeIfPresent(String.self, forKey: .thumbnail)) ?? ""
        id = (try? container.decode(String.self, forKey: .id)) ?? ""
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(thumbnailURL, forKey: .thumbnail)
        try container.encode(id, forKey: .id)
    }
    
}

extension Meal: Comparable {
    static func < (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.name < rhs.name
    }
}


