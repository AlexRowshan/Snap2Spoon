//
//  ExampleViewModel.swift
//  Snap2Spoon
//
//  Created by Alex Rowshan on 10/16/24.
//

import Foundation
import Combine

class ExampleViewModel: ObservableObject {
    @Published var counterText: String = "0"
    
    private var model = ExampleModel()

    func incrementCounter() {
        model.counter += 1
        updateCounterText()
    }

    func resetCounter() {
        model.counter = 0
        updateCounterText()
    }

    private func updateCounterText() {
        counterText = "\(model.counter)"
    }
}
