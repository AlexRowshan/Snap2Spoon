import SwiftUI

struct RecipeView: View {
    let recipes: [RecipeModel]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(recipes) { recipe in
                    VStack(alignment: .leading, spacing: 20) {
                        headerView(recipe: recipe)
                        ingredientsSection(recipe: recipe)
                        instructionsSection(recipe: recipe)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                   
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }

    private func headerView(recipe: RecipeModel) -> some View {
        VStack(spacing: 8) {
            Text(recipe.name)
                .font(.system(size: 34, weight: .bold))

            HStack(spacing: 12) {
                Text(recipe.duration)
                    .foregroundColor(.gray)
                Text(recipe.difficulty)
                    .foregroundColor(.gray)
            }
            .font(.system(size: 17))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func sectionHeaderView(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 24, weight: .semibold))
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black.opacity(0.3))
        }
    }

    private func lineItemView(_ text: String) -> some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 17))
            .padding(.vertical, 4)
    }

    private func ingredientsSection(recipe: RecipeModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeaderView("Ingredients")
            ForEach(recipe.ingredients, id: \ .self) { ingredient in
                lineItemView(ingredient)
            }
        }
    }

    private func instructionsSection(recipe: RecipeModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeaderView("Instructions")
            ForEach(recipe.instructions, id: \ .self) { instruction in
                lineItemView(instruction)
            }
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var sampleRecipes: [RecipeModel] = [
        RecipeModel(
            name: "Spaghetti Carbonara",
            duration: "30 mins",
            difficulty: "Medium",
            ingredients: [
                "400g spaghetti",
                "200g pancetta",
                "4 large eggs",
                "100g Pecorino Romano",
                "100g Parmigiano Reggiano",
                "Black pepper",
                "Salt"
            ],
            instructions: [
                "1. Bring a large pot of salted water to boil",
                "2. Cook spaghetti according to package instructions",
                "3. While pasta cooks, crisp the pancetta in a pan",
                "4. Beat eggs with grated cheese and pepper",
                "5. Combine hot pasta with egg mixture and pancetta",
                "6. Serve immediately with extra cheese and pepper"
            ]
        )
    ]

    static var previews: some View {
        RecipeView(recipes: sampleRecipes)
    }
}
