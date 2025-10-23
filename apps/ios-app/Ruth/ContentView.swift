import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            // Chat messages view
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageView(message: message)
                                .id(message.id)
                        }
                    }
                }
                .onChange(of: viewModel.messages.count) { _ in
                    // Scroll to the bottom when a new message is added
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Input area
            HStack {
                TextField("Ask Ruth...", text: $viewModel.inputText)
                    .textFieldStyle(.roundedBorder)
                    .disabled(viewModel.isGenerating)

                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                }
                .disabled(viewModel.inputText.isEmpty || viewModel.isGenerating)
            }
            .padding()
        }
        .navigationTitle("Ruth")
    }
}

/// A view that displays a single chat message.
struct MessageView: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
                Text(message.text)
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.text)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)

                    if let decision = message.routeDecision {
                        switch decision {
                        case .local:
                            Label("Processed Locally", systemImage: "cpu")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        case .cloud(let reason):
                            Label("Sent to Cloud: \(reason)", systemImage: "cloud.fill")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}


#Preview {
    ContentView()
}
