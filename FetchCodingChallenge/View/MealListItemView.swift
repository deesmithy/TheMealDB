//
//  MealListItemView.swift
//  FetchCodingChallenge
//
//  Created by Donovan Smith on 7/1/24.
//

import SwiftUI

struct MealListItemView: View {
    var meal: Meal
    var body: some View {
        HStack {
            Group {
                if let url = URL(string: meal.thumbnailURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }//: AsyncImage
                } else {
                    Image(systemName: "takeoutbag.and.cup.and.straw")
                }
            }//: Group
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(meal.name)
                .font(.title2)
                .padding()
        }//: HStack
        
        
        
        
    }
}

#Preview {
    MealListItemView(meal: Meal(name: "Teriyaki Chicken Casserole", thumbnailURL: "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg", id: "52772"))
}
