//
//  OpenAIChatResponse.swift
//  Snap2Spoon
//
//  Created by Cory DeWitt on 11/13/24.
//
import Foundation

struct OpenAIChatResponse: Decodable {
    let id: String
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}

struct OpenAIChatMessage: Decodable {
    let role: String
    let content: String
}
