//
//  HomeView.swift
//  FetchCodingChallenge
//
//  Created by Donovan Smith on 7/1/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: ViewModel
    
    init() {
        #if DEBUG
        if UITestingHelper.isUITesting {

            _viewModel = StateObject(wrappedValue: ViewModel(mealsService: MockMealsService()))
        } else {
            _viewModel = StateObject(wrappedValue: ViewModel())
        }
        #else
        _viewModel = StateObject(wrappedValue: ViewModel())
        
        #endif
    }
    
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                if viewModel.meals.isEmpty && viewModel.hasLoaded {
                    VStack {
                        Text("Something went wrong. Sorry about that!")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                    .accessibilityIdentifier("ErrorView")
                }
                List(viewModel.meals, id: \.id) { meal in
                    NavigationLink(destination: MealDetailsView(meal: meal)) {
                        MealListItemView(meal: meal)
                    }//: NavigationLink
                }//: List
                .accessibilityIdentifier("mealsList")
                .scrollIndicators(.hidden)
                .listStyle(.plain)
                .overlay(alignment: .trailing) {
                    VStack(spacing: 5) {
                        ForEach(viewModel.firstLetters, id: \.self) { letter in
                            Text(String(letter))
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                                .allowsHitTesting(true)
                        }//: ForEach
                    }//: VStack
                    .overlay(
                        GeometryReader { geo in
                            Rectangle().fill(Color(.systemBackground).opacity(0.02))
                                .gesture(
                                    DragGesture(minimumDistance: 0).onChanged({ gesture in
                                        
                                        scrollProxy.scrollTo(viewModel.mealIdFor(gesture: gesture, geo: geo), anchor: .top)
                                        
                                    }).onEnded({ gesture in
                                        
                                        scrollProxy.scrollTo(viewModel.mealIdFor(gesture: gesture, geo: geo), anchor: .top)
                                        
                                    })
                                )
                        }
                    )
                    
                }//: overlay
                
            }//: ScrollViewReader
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(content: {
                        ForEach(MealCategory.allCases, id: \.self) { category in
                            Button(action: {
                                viewModel.category = category
                            }, label: {
                                if category == viewModel.category {
                                    Image(systemName: "checkmark")
                                }
                                Text(category.rawValue)
                            })
                        }//: ForEach
                    }, label: {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .font(.title3)
                            .foregroundColor(.black)
                    })
                    
                } //: ToolbarItem
            }
            .navigationTitle("The Meal DB")
            .toolbarBackground(Color.green, for: .navigationBar)
            .toolbar(.visible, for: .navigationBar)
        }//: NavigationStack
        
        
        .onChange(of: viewModel.category) {
            viewModel.getMeals()
        }
        .onAppear {
            viewModel.getMeals()
        }//: onAppear
    }//: body
}//: HomeView




extension HomeView {
    class ViewModel: ObservableObject {
        @Published var meals: [Meal] = []
        @Published var category: MealCategory = .dessert
        @Published var firstLetters: [Character] = []
        
        @Published var hasLoaded: Bool = false
        
        let mealsService: MealsService
        
        init(mealsService: MealsService = MealsServiceImpl()) {
            
            self.mealsService = mealsService
        }
        
        func getMeals() {
            Task {
                let meals = await mealsService.getMeals(for: category)
                let firstLetters = Set(meals.compactMap { $0.name.first })
                await MainActor.run {
                    self.meals = meals
                    self.firstLetters = firstLetters.sorted()
                    self.hasLoaded = true
                }
            }
        }
        
        func idForLetter(_ letter: Character) -> String {
            guard let meal = meals.first(where: { $0.name.first == letter }) else {
                return ""
            }
            return meal.id
        }
        
        func letterForDragFraction(_ dragFraction: CGFloat) -> Character {
            var index = Int(dragFraction * CGFloat(firstLetters.count))
            index = max(min(index, firstLetters.count - 1), 0)
            return firstLetters[index]
        }
        
        func mealIdFor(gesture: DragGesture.Value, geo: GeometryProxy) -> String {
            let topOfStack = geo.frame(in: .local).minY
            let yLocation = gesture.location.y
            let height = geo.frame(in: .global).height
            let dragFraction = (yLocation - topOfStack) / height
            let letter = letterForDragFraction(abs(dragFraction))
            return idForLetter(letter)
        }
    }
}

#Preview {
    HomeView()
}
