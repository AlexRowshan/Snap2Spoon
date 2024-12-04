//
//  ChatViewModel.swift
//  Snap2Spoon
//
//  Created by Cory DeWitt on 11/13/24.
//
import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var chatMessages: [ChatMessage] = []
    @Published var messageText: String = ""
    
    private let openAIService = OpenAIService()
    private var cancellables = Set<AnyCancellable>() 
    
    func sendMessage() {
        let myMessage = ChatMessage(
            id: UUID().uuidString,
            content: messageText,
            dateCreated: Date(),
            sender: .me
        )
        chatMessages.append(myMessage)
        
        openAIService.sendMessage(messages: chatMessages)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                if let textResponse = response.choices.first?.message.content {
                    let gptMessage = ChatMessage(
                        id: UUID().uuidString,
                        content: textResponse,
                        dateCreated: Date(),
                        sender: .gpt
                    )
                    self.chatMessages.append(gptMessage)
                }
            }
            .store(in: &cancellables)
        
        messageText = ""
    }
    
    

}
