//
//  CaputredImageViewModel.swift
//  Snap2Spoon
//
//  Created by Cory DeWitt on 11/13/24.
//

import Foundation
import Combine
import UIKit

class CapturedImageViewModel: ObservableObject {
    @Published var generatedText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var testImage: UIImage? = nil
    @Published var recipes: [RecipeModel] = []
    private var hasProcessedImage = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func processImage(image: UIImage) {
        // Prevent multiple processing of the same image
        guard !hasProcessedImage else { return }
        hasProcessedImage = true
        
        guard let base64Image = encodeImageToBase64(image: image) else {
            self.errorMessage = "Failed to encode image."
            self.isLoading = false
            return
        }

        // Reset state
        self.isLoading = true
        self.errorMessage = nil
        self.recipes = []

        let openAIService = OpenAIService()
        openAIService.sendImageMessage(base64Image: base64Image)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    print("API Error: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    print("API request completed")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                if let content = response.choices.first?.message.content {
                    print("Received content: \(content)")
                    self.generatedText = content
                    self.parseRecipes(from: content)
                } else {
                    self.errorMessage = "No response from GPT."
                }
                self.isLoading = false
            }
            .store(in: &cancellables)
    }

    private func encodeImageToBase64(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to create JPEG data")
            return nil
        }
        return imageData.base64EncodedString()
    }
    
    private func parseRecipes(from jsonString: String) {
        print("Attempting to parse JSON: \(jsonString)")
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert string to data")
            self.errorMessage = "Failed to convert response to data."
            return
        }
        
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                let decoder = JSONDecoder()
                let recipes = try decoder.decode([RecipeModel].self, from: data)
                print("Successfully parsed \(recipes.count) recipes")
                self.recipes = recipes
            } else {
                print("Invalid JSON format")
                self.errorMessage = "Failed to parse recipes: Invalid JSON format."
            }
        } catch {
            print("JSON parsing error: \(error)")
            self.errorMessage = "Failed to parse recipes: \(error.localizedDescription)"
        }
    }
}
