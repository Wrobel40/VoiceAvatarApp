import Foundation

class OpenAIManager: ObservableObject {
    @Published var responseText = ""
    @Published var isProcessing = false
    
    private var apiKey: String {
        UserDefaults.standard.string(forKey: "openai_api_key") ?? ""
    }
    
    private var conversationHistory: [[String: String]] = []
    private let maxHistoryLength = 10
    
    func sendMessage(_ message: String) async {
        guard !apiKey.isEmpty else {
            DispatchQueue.main.async {
                self.responseText = "Proszę skonfigurować klucz API w ustawieniach."
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isProcessing = true
            self.responseText = ""
        }
        
        // Add user message to history
        conversationHistory.append(["role": "user", "content": message])
        
        // Keep only recent messages
        if conversationHistory.count > maxHistoryLength {
            conversationHistory.removeFirst()
        }
        
        do {
            let response = try await callOpenAI()
            
            DispatchQueue.main.async {
                self.responseText = response
                self.isProcessing = false
            }
            
            // Add assistant response to history
            conversationHistory.append(["role": "assistant", "content": response])
            
        } catch {
            DispatchQueue.main.async {
                self.responseText = "Błąd: \(error.localizedDescription)"
                self.isProcessing = false
            }
        }
    }
    
    private func callOpenAI() async throws -> String {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let systemMessage: [String: String] = [
            "role": "system",
            "content": "Jesteś pomocnym asystentem głosowym. Odpowiadaj zwięźle i naturalnie, jak w rozmowie. Używaj prostego języka polskiego."
        ]
        
        var messages = [systemMessage]
        messages.append(contentsOf: conversationHistory)
        
        let body: [String: Any] = [
            "model": "gpt-4",
            "messages": messages,
            "max_tokens": 150,
            "temperature": 0.7
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw OpenAIError.invalidResponse
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let choices = json?["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw OpenAIError.noContent
        }
        
        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func clearHistory() {
        conversationHistory.removeAll()
        responseText = ""
    }
}

enum OpenAIError: LocalizedError {
    case invalidResponse
    case noContent
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Nieprawidłowa odpowiedź z serwera"
        case .noContent:
            return "Brak treści w odpowiedzi"
        }
    }
}
