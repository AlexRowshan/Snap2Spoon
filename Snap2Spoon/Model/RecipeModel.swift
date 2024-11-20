//
//  RecipeModel.swift
//  Snap2Spoon
//
//  Created by Ashwin Sanjaye on 11/19/24.
//

import Foundation

struct RecipeModel: Identifiable {
    var id: ObjectIdentifier
    let name:String
    let duration: String
    let difficulty: String
    let ingredients: [String]
    let instructions: [String]
}
