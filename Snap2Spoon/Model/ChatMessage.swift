//
//  OpenAIModels.swift
//  Snap2Spoon
//
//  Created by Cory DeWitt on 11/13/24.
//

import Foundation

struct ChatMessage: Identifiable {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}

enum MessageSender {
    case me
    case gpt
    
    var role: String {
        switch self {
        case .me:
            return "user"
        case .gpt:
            return "assistant"
        }
    }
}
