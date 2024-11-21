import SwiftUI

struct CapturedImageView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CapturedImageViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Display the captured image at the top
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()

                // Show a loading indicator while processing the image
                if viewModel.isLoading {
                    ProgressView("Processing Image...")
                        .padding()
                }

                // Display the recipes if available
                if !viewModel.recipes.isEmpty {
                    ScrollView {
                        RecipeView(recipes: viewModel.recipes)  // Use RecipeView to display generated recipes
                            .padding()
                    }
                }

                // Display an error message if any
                if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                }

                // Button to start processing the image
                Button(action: {
                    viewModel.processImage(image: image)
                }) {
                    Text("Process Receipt")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#7cd16b"))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom)
                .disabled(viewModel.isLoading)
            }
            .navigationTitle("Captured Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
}
