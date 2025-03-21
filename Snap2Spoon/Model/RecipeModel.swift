//
//  RecipeModel.swift
//  Snap2Spoon
//
//  Created by Ashwin Sanjaye on 11/19/24.
//

import Foundation

struct RecipeModel: Identifiable, Codable  {
    var id: UUID? = UUID()
    let name:String
    let duration: String
    let difficulty: String
    let ingredients: [String]
    let instructions: [String]
    
    
    init(name: String, duration: String, difficulty: String, ingredients: [String], instructions: [String]) {
        self.id = UUID()  // Generates a unique identifier for each instance
        self.name = name
        self.duration = duration
        self.difficulty = difficulty
        self.ingredients = ingredients
        self.instructions = instructions
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case duration
        case difficulty
        case ingredients
        case instructions
    }
}


