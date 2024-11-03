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
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.capturePhoto()
                                if let image = viewModel.photo {
                                    onPhotoCaptured(image)
                                    dismiss()
                                }
                            } catch {
                                // Error is handled by the ViewModel
                            }
                        }
                    }) {
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.white)
                    }
                    .padding(.bottom, 30)
                }
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
