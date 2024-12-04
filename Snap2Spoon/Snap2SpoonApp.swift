//
//  Snap2SpoonApp.swift
//  Snap2Spoon
//
//  Created by Alex Rowshan on 10/16/24.
//

import SwiftUI

@main
struct Snap2SpoonApp: App {
    var body: some Scene {
        WindowGroup {
            Homepage()
        }
    }
    
    init() {
        for familyName in UIFont.familyNames{
            print(familyName)
            
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print("-- \(fontName)")
            }
        }

    }
}
