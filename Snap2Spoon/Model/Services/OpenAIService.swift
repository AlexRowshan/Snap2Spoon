//
//  OpenAIService.swift
//  Snap2Spoon
//
//  Created by Cory DeWitt on 11/13/24.
//

import Foundation
import Alamofire
import Combine

class OpenAIService {
    let baseUrl = "https://api.openai.com/v1/"
    let otherURL = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(messages: [ChatMessage]) -> AnyPublisher<OpenAIChatResponse, Error> {
        let chatMessages = messages.map { message in
            ["role": message.sender == .me ? "user" : "assistant", "content": message.content]
        }
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": chatMessages
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIAPIKey)",
            "Content-Type": "application/json"
        ]
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            
            AF.request(
                self.baseUrl + "chat/completions",
                method: .post,
                parameters: body,
                encoding: JSONEncoding.default,
                headers: headers
            )
            .validate()
            .responseDecodable(of: OpenAIChatResponse.self) { response in
                if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON: \(jsonString)")
                }
                
                switch response.result {
                case .success(let result):
                    promise(.success(result))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func sendImageMessage(base64Image: String) -> AnyPublisher<OpenAIChatResponse, Error> {
//        let prompt = ""
//        if let path = Bundle.main.path(forResource: "prompt", ofType: "txt") {
//            do {
//                _ = try String(contentsOfFile: path, encoding: .utf8)
//                
//            } catch {
//                print("Error loading prompt from file: \(error)")
//            }
//        }
        let prompt = """
        The picture provided is of a grocery receipt. You are an assistant whose job is to create recipes.

        Your first task is to read through this receipt and create a list of ingredients strictly from the receipt.

        There are a certain number of ingredients that can be labeled as "Common Household Ingredients", which I have provided below:

        Common Household Ingredients:
        "Pantry Basics:
            - Flour (all-purpose)
            - Sugar (granulated, brown)
            - Salt (table, kosher)
            - Black pepper
            - Baking soda
            - Baking powder
            - Vanilla extract
            - Cooking oils (vegetable, olive)
            - Vinegar (white, apple cider)
        Seasonings/Spices:
            - Garlic powder
            - Onion powder
            - Cinnamon
            - Paprika
            - Red pepper flakes
            - Italian seasoning
            - Bay leaves
            - Dried oregano
            - Dried basil
            - Ground cumin
        Refrigerator Staples:
            - Butter
            - Eggs
            - Milk
            - Mustard
            - Mayonnaise
            - Ketchup
            - Soy sauce
            - Hot sauce
            - Worcestershire sauce
        Basic Produce:
            - Garlic
            - Onions
            - Lemons/Limes (these are borderline - some might not always have them)

        Please create a combined list of all of the items from the receipt and this Common Household Ingredients list. Do not print out this list.

        Now, please generate an array of 1 recipe in JSON format matching the following structure:

        [
          {
            "name": "Recipe Name",
            "duration": "Cooking Time in minutes",
            "difficulty": "Easy/Medium/Hard",
            "ingredients": ["Ingredient 1", "Ingredient 2", "..."],
            "instructions": ["Step 1", "Step 2", "..."]
          },
          ...
        ]

        Ensure that the JSON is strictly valid and can be parsed by a JSON decoder. The response should only contain the JSON array of recipes without any additional text, headers, backticks, or symbols. Do not add any markdown formatting (e.g., no ```json). Only output the JSON array directly. Ensure the instructions are detailed.

        """

            let messages: [[String: Any]] = [
                    [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": prompt
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpeg;base64,\(base64Image)"
                            ]
                        ]
                    ]
                ]
            ]
            
            let parameters: [String: Any] = [
                "model": "gpt-4o",
                "messages": messages,
                "max_tokens": 300
            ]
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(Constants.openAIAPIKey)",
                "Content-Type": "application/json"
            ]
            
            return Future { promise in
                let request = AF.request(
                    self.otherURL,
                    method: .post,
                    parameters: parameters,
                    encoding: JSONEncoding.default,
                    headers: headers
                )
                
                request.responseData { response in
                    print("Request URL: \(self.baseUrl)")
                    print("Request Headers: \(headers)")
                    print("Request Parameters: \(parameters)")
                    
                    if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response Data: \(responseString)")
                    }
                    
                    if let error = response.error {
                        print("Request Error: \(error)")
                    }
                    
                    switch response.result {
                    case .success(let data):
                        do {
                            let decodedResponse = try JSONDecoder().decode(OpenAIChatResponse.self, from: data)
                            promise(.success(decodedResponse))
                        } catch {
                            print("Decoding Error: \(error)")
                            promise(.failure(error))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
        
        
    }

