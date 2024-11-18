//
//  OpenAIModels.swift
//  Snap2Spoon
//
//  Created by Cory DeWitt on 11/13/24.
//

import Foundation

struct OpenAICompletionsBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int?
}

struct OpenAICompletionsResponse: Decodable {
    let id: String
    let choices: [OpenAICompletionsChoice]
}

struct OpenAICompletionsChoice: Decodable {
    let text: String
}

struct ChatMessage: Identifiable {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}

enum MessageSender {
    case me
    case gpt
}
