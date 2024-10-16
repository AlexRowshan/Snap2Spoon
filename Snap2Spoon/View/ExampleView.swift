//
//  ExampleView.swift
//  Snap2Spoon
//
//  Created by Alex Rowshan on 10/16/24.
//

import SwiftUI

struct ExampleView: View {
    
    @StateObject private var viewModel = ExampleViewModel()

    var body: some View {
        VStack(spacing: 20) {
            
            Text(viewModel.counterText)
                .font(.largeTitle)
                .padding()

            
            Button(action: {
                viewModel.incrementCounter()
            }) {
                Text("Increment")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            
            Button(action: {
                viewModel.resetCounter()
            }) {
                Text("Reset")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    ExampleView()
}
