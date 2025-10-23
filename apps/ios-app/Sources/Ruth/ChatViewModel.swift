import Foundation
import SwiftUI

/// Represents a single message in the chat.
struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    var text: String
    let isFromUser: Bool
    var routeDecision: RouteDecision?
}

/// Manages the state and logic for the chat view.
@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var engineState: MLCEngine.State = .idle

    private let router = Router()
    private let llmEngine = MLCEngine()

    init() {
        // Add an initial welcome message.
        messages.append(ChatMessage(text: "Hello! I'm Ruth. How can I help you today?", isFromUser: false, routeDecision: .local))

        // Observe the state of the LLM engine.
        llmEngine.$state.assign(to: &$engineState)
    }

    /// Sends the user's message and generates a response.
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let userMessage = ChatMessage(text: inputText, isFromUser: true, routeDecision: nil)
        messages.append(userMessage)
        let prompt = inputText
        inputText = ""

        Task {
            let decision = router.decideRoute(for: prompt)

            switch decision {
            case .local:
                let responseMessage = ChatMessage(text: "", isFromUser: false, routeDecision: .local)
                let responseIndex = messages.count
                messages.append(responseMessage)

                await llmEngine.generateResponse(for: prompt) { partialResponse in
                    // Update the message in place to show the streaming response
                    self.messages[responseIndex].text = partialResponse
                }
            case .cloud(let reason):
                let responseMessage = ChatMessage(text: "This request will be sent to the cloud. Reason: \(reason)", isFromUser: false, routeDecision: decision)
                messages.append(responseMessage)
            }
        }
    }
}
