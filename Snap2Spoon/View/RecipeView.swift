//
//  RecipeView.swift
//  Snap2Spoon
//
//  Created by Kevin Gerges on 11/19/24.
//

import SwiftUI

struct RecipeView: View {
    let recipe: Recipe
    
    private var headerView: some View {
        VStack(spacing: 1) {
            Text(recipe.name)
                .font(.system(size: 34, weight: .regular))
            HStack(spacing: 6) {
                Text(recipe.duration)
                    .foregroundColor(.gray)
                Text(recipe.difficulty)
                    .foregroundColor(.gray)
            }
            .font(.system(size: 17))
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 1)
    }
    
    private func sectionHeaderView(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 28, weight: .bold))
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black.opacity(0.3))
        }
        .padding(.bottom, 8)
    }
    
    private func lineItemView(_ text: String) -> some View {
        VStack(spacing: 0) {
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 17))
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black.opacity(0.2))
        }
    }
    
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeaderView("Ingredients")
            
            VStack(spacing: 24) {
                ForEach(recipe.ingredients, id: \.self) { ingredient in
                    lineItemView(ingredient)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 40)
    }
    
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeaderView("Instructions")
            
            VStack(spacing: 24) {
                ForEach(recipe.instructions, id: \.self) { instruction in
                    lineItemView(instruction)
                }
            }
        }
        .padding(.horizontal, 24)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
            ingredientsSection
            instructionsSection
            Spacer()
        }
        .background(Color.white)
    }
}

//struct Recipe_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeView(recipe: Recipe(
//            name: "Spaghetti Carbonara",
//            duration: "30 minutes",
//            difficulty: "Medium",
//            ingredients: [
//                "400g spaghetti",
//                "200g pancetta",
//                "4 large eggs",
//                "100g Parmesan cheese",
//                "Black pepper"
//            ],
//            instructions: [
//                "Cook pasta in salted water",
//                "Fry pancetta until crispy",
//                "Mix eggs and cheese",
//                "Combine all ingredients",
//                "Serve with extra cheese and pepper"
//            ]
//        ))
//    }
//}

