import Foundation

/// Represents the decision made by the router.
enum RouteDecision {
    case local
    case cloud(reason: String)
}

/// The Router class is responsible for deciding where to route a user's request.
class Router {
    // A simple threshold for the maximum number of tokens to be processed locally.
    private let maxLocalTokens: Int

    init(maxLocalTokens: Int = 256) {
        self.maxLocalTokens = maxLocalTokens
    }

    /// Decides the route for a given prompt based on a set of policies.
    ///
    /// - Parameter prompt: The user's input string.
    /// - Returns: A `RouteDecision` indicating whether to use the local SLM or the cloud LLM.
    func decideRoute(for prompt: String) -> RouteDecision {
        // **Policy 1: Input Length**
        // This is a simplified tokenizer that just counts words. A real implementation
        // would use a proper tokenizer from the SLM.
        let tokenCount = prompt.split(separator: " ").count

        if tokenCount > maxLocalTokens {
            return .cloud(reason: "Input length (\(tokenCount) tokens) exceeds local limit of \(maxLocalTokens).")
        }

        // In the future, more complex routing logic will be added here, such as:
        // - PII/PHI detection
        // - Uncertainty/entropy calculation from a draft SLM response
        // - Device status (battery, network)
        // - User-defined policies

        return .local
    }
}
