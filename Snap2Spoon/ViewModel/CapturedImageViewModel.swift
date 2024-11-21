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
    var onGeneratedText: ((String) -> Void)?


    private var cancellables = Set<AnyCancellable>()

    func processImage(image: UIImage) {
        guard let base64Image = encodeImageToBase64(image: image) else {
            self.errorMessage = "Failed to encode image."
            return
        }

        self.isLoading = true
        self.errorMessage = nil

        let openAIService = OpenAIService()
        openAIService.sendImageMessage(base64Image: base64Image)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                if let content = response.choices.first?.message.content {
                    self?.generatedText = content
                    self?.parseRecipes(from: content)
                } else {
                    self?.errorMessage = "No response from GPT."
                }
            }
            .store(in: &cancellables)
    }

    private func encodeImageToBase64(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        return imageData.base64EncodedString()
    }
    
    private func parseRecipes(from jsonString: String) {
        // Unescape the JSON string if necessary
        guard let jsonData = jsonString.data(using: .utf8) else {
            self.errorMessage = "Failed to convert response to data."
            return
        }
        
        do {
            // Try parsing with JSONSerialization to ensure JSON format is correct
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                // Convert the JSON object back to Data for decoding into RecipeModel
                let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                let decoder = JSONDecoder()
                let recipes = try decoder.decode([RecipeModel].self, from: data)
                self.recipes = recipes
            } else {
                self.errorMessage = "Failed to parse recipes: Invalid JSON format."
            }
        } catch {
            self.errorMessage = "Failed to parse recipes: \(error.localizedDescription)"
        }
    }

    
    func testSendImageMessage() {
            guard let image = UIImage(named: "testImage") else {
                self.errorMessage = "Test image not found."
                return
            }
            self.testImage = image 
            processImage(image: image)
        }
    
}
