//
//  CapturedImageView.swift
//  Snap2Spoon
//
//  Created by Cory DeWitt on 11/3/24.
//

import SwiftUI

struct CapturedImageView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                Button(action: {
                    // PROCESSING LOGIC
                }) {
                    Text("Process Receipt")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#7cd16b"))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationTitle("Captured Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
}
