//
//  LoadingPageView.swift
//  Snap2Spoon
//
//  Created by Alex Rowshan on 11/13/24.
//

import SwiftUI

struct LoadingPageView: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Color(hex: "#FCFCFC") // #FFFFFF wont show shadow as much
                    .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Header
                Text("Snap2Spoon")
                    .font(.custom("Scripto", size: 32))
                    .foregroundColor(Color(hex: "#7FBD61"))
                    .padding(.top, 40)
                    .fontWeight(.bold)
                
                Spacer().frame(height: 90)
                
                // Main content area
                ZStack {
                    // Rotating ingredients
                    ForEach(0..<5) { index in
                        let angle = Double(index) * (360.0 / 5.0)
                        let radius: CGFloat = 170
                        
                        Image(getImageName(index))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 100)
                            .position(
                                x: 200 + radius * cos(CGFloat(angle + rotation) * .pi / 180),
                                y: 200 + radius * sin(CGFloat(angle + rotation) * .pi / 180)
                            )
                            .rotationEffect(.degrees(-rotation)) //
                    }
                    
                    
                    VStack {
                        Text("Creating Recipe...")
                            //.font(.system(size: 18, weight: .medium))
                            .font(.custom("Avenir", size:18))
                            .foregroundColor(Color(hex: "#80D05B"))
                            .italic()
                            .bold()
                        
                        // Center circle
                        ZStack {
                            //outer white circle
                            Circle()
                                .fill(Color.white)
                                .frame(width: 200, height: 200) 
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 5, y: 5)

                            //inner green circle
                            Circle()
                                .fill(Color(hex: "#80D05B").opacity(0.77))
                                .frame(width: 180, height: 180)

                            
                            VStack {
                                
                                Image("receipt2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130, height: 130)
                            }
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
        LoadingPageView()
    }
}
