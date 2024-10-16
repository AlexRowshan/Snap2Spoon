//
//  ExampleViewModel.swift
//  Snap2Spoon
//
//  Created by Alex Rowshan on 10/16/24.
//

import Foundation
import Combine

class ExampleViewModel: ObservableObject {
    // Published property to notify the view of changes
    @Published var counterText: String = "0"
    
    private var model = ExampleModel()

    // Methods to manipulate the counter
    func incrementCounter() {
        model.counter += 1
        updateCounterText()
    }

    func resetCounter() {
        model.counter = 0
        updateCounterText()
    }

    // Update the counter text (View reacts to this)
    private func updateCounterText() {
        counterText = "\(model.counter)"
    }
}
