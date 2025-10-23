import Foundation
import SwiftUI

/// Represents a single message in the chat.
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromUser: Bool
    let routeDecision: RouteDecision?
}

/// Manages the state and logic for the chat view.
@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isGenerating: Bool = false

    private let router = Router()
    private let llmEngine = MLCEngine()

    init() {
        // Add an initial welcome message.
        messages.append(ChatMessage(text: "Hello! I'm Ruth. How can I help you today?", isFromUser: false, routeDecision: .local))
    }

    /// Sends the user's message and generates a response.
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let userMessage = ChatMessage(text: inputText, isFromUser: true, routeDecision: nil)
        messages.append(userMessage)
        let prompt = inputText
        inputText = ""
        isGenerating = true

        Task {
            let decision = router.decideRoute(for: prompt)

            switch decision {
            case .local:
                let responseMessage = ChatMessage(text: "", isFromUser: false, routeDecision: .local)
                let responseIndex = messages.count
                messages.append(responseMessage)

                await llmEngine.generateResponse(for: prompt) { partialResponse in
                    self.messages[responseIndex] = ChatMessage(text: partialResponse, isFromUser: false, routeDecision: .local)
                }
            case .cloud(let reason):
                let responseMessage = ChatMessage(text: "This request will be sent to the cloud. Reason: \(reason)", isFromUser: false, routeDecision: decision)
                messages.append(responseMessage)
            }

            isGenerating = false
        }
    }
}
