//
//  CapturedImageView.swift
//  Snap2Spoon
//
//  Created by Cory DeWitt on 11/3/24.
//

import SwiftUI

struct CapturedImageView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CapturedImageViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()

                if viewModel.isLoading {
                    ProgressView("Processing Image...")
                        .padding()
                }

                if !viewModel.generatedText.isEmpty {
                    ScrollView {
                        Text(viewModel.generatedText)
                            .padding()
                    }
                }

                if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                }

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
