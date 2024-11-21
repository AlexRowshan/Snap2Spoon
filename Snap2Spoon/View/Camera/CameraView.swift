import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var viewModel = CameraViewModel()
    @Environment(\.dismiss) var dismiss
    var onPhotoCaptured: (UIImage) -> Void
    
    var body: some View {
        ZStack {
            if viewModel.isReady {
                PreviewViewWrapper(session: viewModel.captureSession)
                    .ignoresSafeArea()
                
                VStack {
                    // Top Bar
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .shadow(radius: 2)
                        }
                        .padding()
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Camera Controls
                    VStack(spacing: 20) {
                        // Capture Button
                        Button(action: {
                            Task {
                                do {
                                    try await viewModel.capturePhoto()
                                    if let image = viewModel.photo {
                                        onPhotoCaptured(image)
                                        dismiss()
                                    }
                                } catch {
                                    // Error handled by the ViewModel
                                }
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 80, height: 80)
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                                    .frame(width: 70, height: 70)
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
            } else {
                Color.black
                    .ignoresSafeArea()
                ProgressView()
                    .tint(.white)
            }
        }
        .task {
            await viewModel.initialize()
        }
        .alert("Camera Access Required", isPresented: $viewModel.showPermissionAlert) {
            Button("Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {
                dismiss()
            }
        }
        .alert("Camera Error", isPresented: $viewModel.showCameraError) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

struct PreviewViewWrapper: UIViewRepresentable {
    var session: AVCaptureSession
    
    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.setSession(session)
        return view
    }
    
    func updateUIView(_ uiView: PreviewView, context: Context) {
        
    }
}
