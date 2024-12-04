import AVFoundation
import SwiftUI

struct Homepage: View {
    @StateObject private var viewModel = HomepageViewModel()
    @StateObject private var capturedImageViewModel = CapturedImageViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#8AC36F"), Color.white]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Turn your receipts to recipes!")
                            .font(.custom("Avenir Next", size: 18))
                            .foregroundColor(.white)
                            .italic()
                        
                        // underline
                        Rectangle()
                            .fill(Color(hex: "#7FBD61").opacity(0.5))
                            .frame(height: 8)
                            .offset(y: 52)
                            .frame(maxWidth: 280)
                        
                        // snap2spoon logo
                        ZStack(alignment: .bottom) {
                            Text("Snap2Spoon")
                                .font(.custom("Scripto", size: 47))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                            
//                            Rectangle()
//                                .fill(Color(hex: "#7cd16b").opacity(0.5))
//                                .frame(height: 8)
//                                .offset(y: -5)
//                                .frame(maxWidth: 260)
                        }
                    }
                    
                    Spacer().frame(height:30)
                    
                    ZStack {
                        Image("receipt")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 590, height: 400)
                            // needs tilt
                            .rotationEffect(.degrees(7))
                            .offset(x: 25)
                        
                        Image("shopping_cart")
                            .resizable()
                            .frame(width: 180, height: 180)
                            .offset(x: 0, y: -40)
                            .rotationEffect(.degrees(5))
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer().frame(height:15)
                    
                    if let image = viewModel.capturedImage {
                        NavigationLink(destination: ImageView(image: image)) {
                            Text("View Scanned Receipt")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 220, height: 80)
                                .background(Color(hex: "#7cd16b"))
                                .cornerRadius(29)
                                .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 2)
                        }
                    } else {
                        Button(action: {
                            viewModel.showCamera = true
                        }) {
                            Text("Scan Now")
                                .font(.custom("Avenir", size: 30))
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 180, height: 80)
                                .background(Color(hex: "#7FBD61").opacity(0.72))
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.1), radius: 35)
                                .bold()
                            
                            
                        }
//                        NavigationLink(destination: ChatView()) {
//                            Text("GPT Button")
//                                .font(.largeTitle)
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(width: 220, height: 80)
//                                .background(Color(hex: "#7cd16b"))
//                                .cornerRadius(29)
//                                .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 2)
//                        }
                    }
                    
                    Spacer().frame(height: 70)
                }
                .padding(.horizontal, 20)
            }
            .fullScreenCover(isPresented: $viewModel.showCamera) {
                CameraView(onPhotoCaptured: { image in
                    viewModel.handlePhotoCaptured(image)
                })
            }
            .fullScreenCover(isPresented: $viewModel.navigateToImageView) {
                if let image = viewModel.capturedImage {
                    CapturedImageView(image: image)
                }
            }
            .alert("Camera Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
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
