import Foundation
import MLCSwift

/// The main engine for handling on-device LLM inference using MLC.
@MainActor
class MLCEngine {
    private var chatModule: ChatModule!
    private var modelName: String = "Phi-3-mini-4k-instruct-q4f16_1" // Default model

    /// An enumeration for the state of the engine.
    enum State {
        case idle
        case loadingModel
        case generating
        case failed(Error)
    }

    @Published var state: State = .idle

    init() {
        // Asynchronously load the model on initialization.
        Task {
            await loadModel()
        }
    }

    /// Loads the MLC model from the app bundle.
    private func loadModel() async {
        state = .loadingModel
        do {
            self.chatModule = ChatModule(model: modelName)
            state = .idle
            print("MLCEngine: Model \(modelName) loaded successfully.")
        } catch {
            state = .failed(error)
            print("MLCEngine: Error loading model: \(error)")
        }
    }

    /// Generates a response for a given prompt, streaming the output.
    func generateResponse(for prompt: String, progressHandler: @escaping (String) -> Void) async {
        guard case .idle = state else {
            print("MLCEngine: Cannot generate response, not in idle state.")
            return
        }

        state = .generating
        var fullResponse = ""

        do {
            let stream = try chatModule.generate(prompt: prompt)
            for try await partialResponse in stream {
                fullResponse += partialResponse
                progressHandler(fullResponse)
            }
        } catch {
            state = .failed(error)
            print("MLCEngine: Error during generation: \(error)")
        }

        state = .idle
    }

    /// Resets the chat state, clearing the conversation history in the model.
    func reset() {
        chatModule?.reset()
        print("MLCEngine: Chat state reset.")
    }
}
