//
//  HomeView.swift
//  FetchCodingChallenge
//
//  Created by Donovan Smith on 7/1/24.
//

import SwiftUI
import CoreHaptics

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
                                .padding(.horizontal, 6)
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
                                )//: gesture
                        }//: GeometryReader
                    )//: overlay
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
        .onChange(of: viewModel.currentLetterScrolledTo) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }//: body
}//: HomeView




extension HomeView {
    class ViewModel: ObservableObject {
        /// The meals that are currently being displayed
        @Published var meals: [Meal] = []
        
        /// The category of meals that are currently being displayed
        @Published var category: MealCategory = .dessert
        
        /// This is a variable that tracks the first letters of the meals. This is used to create the side menu with only letters that are actually correspond to a meal in the list
        @Published var firstLetters: [Character] = []
        
        /// This is a variable that tracks whether the meals have been loaded. This is used to show an error message if the meals fail to load.
        @Published var hasLoaded: Bool = false
        
        /// This is a letter that tracks the most recent position of the scroll on the side menu. This is used to give haptic feedback when the user scrolls to a new letter.
        @Published var currentLetterScrolledTo: Character = "A"
        
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
        
        /// This function returns the id of the meal that is alphabetically first for the given letter. This is used for the scrolling side menu.
        func idForLetter(_ letter: Character) -> String {
            guard let meal = meals.first(where: { $0.name.first == letter }) else {
                return ""
            }
            return meal.id
        }
        
        /// This function returns the letter that corresponds to the given drag fraction. This is used for the scrolling side menu.
        func letterForDragFraction(_ dragFraction: CGFloat) -> Character {
            var index = Int(dragFraction * CGFloat(firstLetters.count))
            index = max(min(index, firstLetters.count - 1), 0)
            return firstLetters[index]
        }
        
        /// This function returns the meal id for the given drag gesture and geometry proxy. This is used for the scrolling side menu.
        func mealIdFor(gesture: DragGesture.Value, geo: GeometryProxy) -> String {
            let topOfStack = geo.frame(in: .local).minY
            let yLocation = gesture.location.y
            let height = geo.frame(in: .global).height
            let dragFraction = (yLocation - topOfStack) / height
            let letter = letterForDragFraction(abs(dragFraction))
            Task { await MainActor.run {
                currentLetterScrolledTo = letter
            }}
            return idForLetter(letter)
        }
    }
}

#Preview {
    HomeView()
}
