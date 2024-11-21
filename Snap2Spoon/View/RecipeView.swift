import SwiftUI

struct RecipeView: View {
    let recipes: [RecipeModel]
    
    var body: some View {
        ScrollView {
            ForEach(recipes) { recipe in
                VStack(alignment: .leading, spacing: 16) {
                    headerView(recipe: recipe)
                    ingredientsSection(recipe: recipe)
                    instructionsSection(recipe: recipe)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }

    private func headerView(recipe: RecipeModel) -> some View {
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
    
    private func ingredientsSection(recipe: RecipeModel) -> some View {
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
    
    private func instructionsSection(recipe: RecipeModel) -> some View {
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
}
