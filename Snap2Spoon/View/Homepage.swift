//
//  Homepage.swift
//  Snap2Spoon
//
//  Created by Alex Rowshan on 10/29/24.
//

import Foundation
import SwiftUI

struct Homepage: View {
    var body: some View {
        NavigationView {
            ZStack {
                //Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#7cd16b"), Color.white]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all) // Ensure gradient fills the whole screen
                
                VStack {
                    Spacer() // Push elements to the center

                    // Header Text
                    VStack(spacing: 8) {
                        Text("Turn your receipts to recipes!")
                            .font(.custom("ArialMT", size: 20))
                            .foregroundColor(.white)
                            .fontWeight(.bold)

                       
                        ZStack(alignment: .bottom) {
                            Text("Snap2Spoon")
                                .font(.custom("SnellRoundhand", size: 50)) // Use your custom font
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)

                            // Custom underline as a rectangle
                            Rectangle()
                                .fill(Color(hex: "#7cd16b")) // Green color for underline
                                .frame(height: 8) // Thickness of the underline
                                .offset(y: 2) // Adjust offset for perfect alignment with text
                                .frame(maxWidth: 260) // Ensure the underline stretches the width of the text
                        }
                    }

                    Spacer().frame(height: 40) // Adjust spacing for better visual alignment
                    
                    // Receipt Image with Cart Overlay
                    ZStack {
                        Image("receipt")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 390, height: 300) // Wider receipt

                        Image("shopping_cart")
                            .resizable()
                            .frame(width: 180, height: 180) // Doubled cart size
                            .offset(x: 0, y: -40) // Adjusted position to sit on the receipt
                    }
                    .frame(maxWidth: .infinity) // Center the ZStack horizontally
                    
                    Spacer() // Push the button down
                    
                    // Scan Now Button
                    NavigationLink(destination: ExampleView()) {
                        Text("Scan Now")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 80)
                            .background(Color(hex: "#7cd16b")) // Use the desired color #7cd16b
                            .cornerRadius(29)
                            .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 2)
                    }
                    
                    Spacer().frame(height: 70) // Move the button up by reducing spacer height
                }
                .padding(.horizontal, 20) // Ensure content stays within safe screen bounds
            }
        }
    }
}

// Color extension to use hex values in SwiftUI
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // Remove # if present
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

// Preview for SwiftUI
struct HomepagePreview: PreviewProvider {
    static var previews: some View {
        Homepage()
    }
}
