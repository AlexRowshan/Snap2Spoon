//
//  LoadingPageView.swift
//  Snap2Spoon
//
//  Created by Alex Rowshan on 11/13/24.
//

import SwiftUI

struct RecipeGenerationView: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Header
                Text("Snap2Spoon")
                    .font(.custom("SnellRoundhand", size: 32))
                    .foregroundColor(Color(hex: "#7cd16b"))
                    .padding(.top, 40)
                    .fontWeight(.bold)
                
                Spacer().frame(height: 90)
                
                // Main content area
                ZStack {
                    // Rotating ingredients
                    ForEach(0..<5) { index in
                        let angle = Double(index) * (360.0 / 5.0)
                        let radius: CGFloat = 140
                        
                        Image(getImageName(index))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .position(
                                x: 200 + radius * cos(CGFloat(angle + rotation) * .pi / 180),
                                y: 200 + radius * sin(CGFloat(angle + rotation) * .pi / 180)
                            )
                            .rotationEffect(.degrees(-rotation)) // Counter-rotate to keep orientation fixed
                    }
                    
                    // Center text and icon
                    VStack {
                        Text("Creating Recipe...")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color(hex: "#7cd16b"))
                            .italic()
                        
                        // Center circle with recipe icon
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#7cd16b"))
                                .frame(width: 120, height: 120)
                            
                            Image("receipt2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(height: 400)
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
    
    private func getImageName(_ index: Int) -> String {
        let images = ["carrot", "bread", "cheese", "egg", "milk"]
        return images[index]
    }
}

struct RecipeGenerationViewer: PreviewProvider {
    static var previews: some View {
        RecipeGenerationView()
    }
}
