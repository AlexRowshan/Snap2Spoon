//
//  ChatView.swift
//  Snap2Spoon
//
//  Created by Cory DeWitt on 11/13/24.
//
import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @StateObject private var capturedImageViewModel = CapturedImageViewModel()
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.chatMessages, id: \.id) { message in
                    messageView(message: message)
                }
                if capturedImageViewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Processing Image...")
                        Spacer()
                    }
                }
                if !capturedImageViewModel.generatedText.isEmpty {
                    Text(capturedImageViewModel.generatedText)
                        .padding()
                }
            }
            if let errorMessage = capturedImageViewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            
        }
        

        
        Button(action: {
            capturedImageViewModel.testSendImageMessage()
        }) {
            Text("Test Send Image Message")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal)
        }
        .padding(.bottom)
        
        HStack {
            TextField("Type a message...", text: $viewModel.messageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                viewModel.sendMessage()
            }) {
                if let testImage = capturedImageViewModel.testImage {
                    Image(uiImage: testImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.leading)
                }
                Text("Send")
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.trailing)
                                

        }
        .padding(.vertical)
    }

    
    func messageView(message: ChatMessage) -> some View {
        let senderIsMe = message.sender == .me
        return HStack {
            if senderIsMe { Spacer() }
            Text(message.content)
                .foregroundColor(senderIsMe ? .white : .black)
                .padding()
                .background(senderIsMe ? Color.blue : Color.gray.opacity(0.1))
                .cornerRadius(16)
            if !senderIsMe { Spacer() }
        }
    }
}
