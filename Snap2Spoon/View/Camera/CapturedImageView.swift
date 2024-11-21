import SwiftUI

import SwiftUI

struct CapturedImageView: View {
    @StateObject private var viewModel = CapturedImageViewModel()
    @State private var showCamera = false
    @State private var navigateToRecipe = false
    let image: UIImage?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    if viewModel.isLoading {
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("Processing Receipt...")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    } else if image == nil {
                        VStack(spacing: 20) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.blue)
                            
                            Text("Take a Photo of Your Receipt")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                            
                            Text("We'll generate recipe suggestions based on your groceries")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Button(action: {
                                showCamera = true
                            }) {
                                Text("Open Camera")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(12)
                                    .padding(.horizontal, 40)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: RecipeView(recipes: viewModel.recipes),
                        isActive: $navigateToRecipe
                    ) {
                        EmptyView()
                    }
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraView { image in
                    viewModel.processImage(image: image)
                }
            }
            .alert("Error", isPresented: .init(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .navigationTitle("Snap2Spoon")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let image = image {
                    viewModel.processImage(image: image)
                }
            }
            // Instead of using onChange, use a publisher in the ViewModel
            .onReceive(viewModel.$recipes) { recipes in
                if !recipes.isEmpty && !navigateToRecipe {
                    navigateToRecipe = true
                }
            }
        }
    }
}
