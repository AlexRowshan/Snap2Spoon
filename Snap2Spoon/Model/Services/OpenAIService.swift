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
    
    func sendImageMessage(prompt: String, base64Image: String) -> AnyPublisher<OpenAIChatResponse, Error> {
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
            "model": "gpt-4o-mini",
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
