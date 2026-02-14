import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var openAIManager: OpenAIManager
    
    @State private var apiKey: String = ""
    @State private var showSaveConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "1a1a2e")
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "gear")
                            .font(.system(size: 48))
                            .foregroundColor(.white)
                        
                        Text("Ustawienia")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    
                    // API Key Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Klucz API OpenAI")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        SecureField("sk-...", text: $apiKey)
                            .textFieldStyle(CustomTextFieldStyle())
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        Text("Aby uzyskać klucz API, odwiedź platform.openai.com")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.horizontal, 24)
                    
                    // Save Button
                    Button(action: saveSettings) {
                        Text("Zapisz")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "0f3460"))
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // Clear History Button
                    Button(action: clearHistory) {
                        Text("Wyczyść historię konwersacji")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.red.opacity(0.8))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red.opacity(0.5), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Info Section
                    VStack(spacing: 8) {
                        Text("Voice Avatar Assistant")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("v1.0.0")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Zamknij") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            loadSettings()
        }
        .alert("Zapisano", isPresented: $showSaveConfirmation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Ustawienia zostały zapisane pomyślnie")
        }
    }
    
    private func loadSettings() {
        apiKey = UserDefaults.standard.string(forKey: "openai_api_key") ?? ""
    }
    
    private func saveSettings() {
        UserDefaults.standard.set(apiKey, forKey: "openai_api_key")
        showSaveConfirmation = true
    }
    
    private func clearHistory() {
        openAIManager.clearHistory()
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
            )
            .foregroundColor(.white)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(openAIManager: OpenAIManager())
    }
}
