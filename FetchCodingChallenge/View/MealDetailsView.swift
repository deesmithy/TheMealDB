//
//  MealDetailsView.swift
//  FetchCodingChallenge
//
//  Created by Donovan Smith on 7/1/24.
//

import SwiftUI

fileprivate enum Selection {
    case ingredients
    case instructions
}

struct MealDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ViewModel
    
    init(meal: Meal) {
        self.viewModel = ViewModel(meal: meal)
    }
    let screenWidth = UIScreen.main.bounds.width
    @State private var scrollOffset: CGFloat = 0
    @State private var selectedScreen: Selection = .ingredients
    @State private var navBarOpacity: Double = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Group {
                    if let url = URL(string: viewModel.meal.thumbnailURL) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                
                        } placeholder: {
                            ProgressView()
                        }//: AsyncImage
                    } else {
                        Image(systemName: "takeoutbag.and.cup.and.straw")
                    }
                }//: Group
                .aspectRatio(contentMode: .fill)
                .offset(x: 0, y: scrollOffset >= 0 ? -scrollOffset : 0)
                .frame(width: max(screenWidth, screenWidth + 2*scrollOffset), height: max(screenWidth, screenWidth + 2*scrollOffset))
                .frame(width: screenWidth, height: screenWidth)
                
                //MARK: - Header section
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.meal.name)
                        .font(.title)
                        .fontWeight(.bold)
                        
                    HStack {
                        if let category = viewModel.mealDetails?.category {
                            Text(category)
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        if let area = viewModel.mealDetails?.area {
                            Text(area)
                                .font(.headline)
                                .fontWeight(.semibold)
                                
                        }
                    }//: HStack
                    if let tags = viewModel.mealDetails?.tags {
                        Text("#\(tags.replacingOccurrences(of: ", ", with: ",").replacingOccurrences(of: ",", with: "  #"))")
                            .font(.subheadline)
                    }
                } //: Vstack
                .padding()
                
                //MARK: Information Section
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                selectedScreen = .ingredients
                            }
                        }, label: {
                            Text("Ingredients")
                                .padding(8)
                                .frame(maxWidth: .infinity)
                                .background(selectedScreen == .ingredients ? Color.green : Color.clear)
                                .foregroundColor(selectedScreen == .ingredients ? Color.white : Color.black)
                        })
                        
                        Button(action: {
                            withAnimation {
                                selectedScreen = .instructions
                            }
                        }, label: {
                            Text("Instructions")
                                .padding(8)
                                .frame(maxWidth: .infinity)
                                .background(selectedScreen == .instructions ? Color.green : Color.clear)
                                .foregroundColor(selectedScreen == .instructions ? Color.white : Color.black)
                        })
                    }//: HStack
                    
                }
                Divider()
                
                switch selectedScreen {
                    case .ingredients:
                        if let mealDetails = viewModel.mealDetails {
                            VStack(alignment: .leading) {
                                ForEach(mealDetails.ingredients.indices, id: \.self) { index in
                                    HStack {
                                        Text(mealDetails.ingredients[index])
                                        
                                        Spacer(minLength: 0)
                                        
                                        Text("\(mealDetails.measures[index])")
                                    }
                                    .padding(12)
                                    Divider()
                                    
                                }//: ForEach
                            }//: VStack
                        }//: if let mealDetails
                    case .instructions:
                        VStack {
                            ForEach(viewModel.instructions.indices, id: \.self) { index in
                                HStack(alignment: .top, spacing: 0) {
                                    //This displays the step number in the instructions spaced so that any reasonable number of instructions will fit (1-99)
                                    Text("00").opacity(0)
                                        .overlay(alignment: .leading) {
                                            Text("\(index + 1)")
                                        }
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.tertiary)
                                    VStack(alignment: .leading) {
                                        Text("\(viewModel.instructions[index])")
                                        Divider()
                                    }//: VStack
                                }//: HStack
                            } //: ForEach
                        }//: VStack
                        .padding()
                }//: switch
            }//: VStack
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("timelineScroll")).origin)
            })
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value.y
                navBarOpacity = max(0, -2*scrollOffset/screenWidth)
            }
        }//: ScrollView
        .accessibilityIdentifier("mealDetailsView")
        .ignoresSafeArea(.container, edges: .top)
        .toolbar {
            if let videoURL = URL(string: viewModel.mealDetails?.youtubeURL ?? "") {
                ToolbarItem(placement: .topBarTrailing) {
                    Link(destination: videoURL, label: {
                        Image(systemName: "play.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .padding(8)
                            .background(Circle().fill(Color(.systemBackground).opacity(1-navBarOpacity)))
                            .foregroundStyle(.black)
                    })
                }
            }//: if let videoURL
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .padding(8)
                        .background(Circle().fill(Color(.systemBackground).opacity(1-navBarOpacity)))
                        .foregroundStyle(.black)
                })
            }
        }//: toolbar
        .toolbarBackground(Color(.green).opacity(navBarOpacity), for: .navigationBar)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.getMealDetails()
        } //: onAppear
        
    }
}

extension MealDetailsView {
    class ViewModel: ObservableObject {
        init(meal: Meal, mealsService: MealsService = MealsServiceImpl()) {
            self.meal = meal
            self.mealsService = mealsService
        }
        @Published var meal: Meal
        @Published var mealDetails: MealDetails?
        @Published var instructions: [String] = []
         
        let mealsService: MealsService
        
        
        
        func getMealDetails() {
            Task {
                let mealDetails = await mealsService.getMealDetails(mealId: meal.id)
                await MainActor.run {
                    self.mealDetails = mealDetails
                    // Get each new paragraph as a new instruction
                    var instructions: [String] = mealDetails?.instructions?.components(separatedBy: "\n") ?? []
                    // Remove any empty strings (which are caused by inconsistent spacing from the server.
                    instructions = instructions.filter({ !$0.removingWhiteSpaces().isEmpty })
                    self.instructions = instructions
                }
            }
        }
    } //: ViewModel
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}


#Preview {
    NavigationStack {
        MealDetailsView(meal: Meal(name: "Teriyaki Chicken Casserole", thumbnailURL: "https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg", id: "52772"))
    }//: NavigationStack
}
