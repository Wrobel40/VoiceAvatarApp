import SwiftUI
import AVFoundation
import Speech

struct ContentView: View {
    @StateObject private var voiceManager = VoiceManager()
    @StateObject private var openAIManager = OpenAIManager()
    @State private var isListening = false
    @State private var showSettings = false
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Voice Assistant")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { showSettings.toggle() }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                // 3D Avatar Container
                AvatarSceneView(
                    isSpeaking: voiceManager.isSpeaking || openAIManager.isProcessing,
                    audioLevel: voiceManager.audioLevel
                )
                .frame(height: 400)
                .padding(.vertical, 20)
                
                // Transcript Display
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if !voiceManager.recognizedText.isEmpty {
                            MessageBubble(
                                text: voiceManager.recognizedText,
                                isUser: true
                            )
                        }
                        
                        if !openAIManager.responseText.isEmpty {
                            MessageBubble(
                                text: openAIManager.responseText,
                                isUser: false
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(maxHeight: 200)
                
                Spacer()
                
                // Status Indicator
                HStack {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 12, height: 12)
                    
                    Text(statusText)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.bottom, 20)
                
                // Voice Control Button
                Button(action: toggleListening) {
                    ZStack {
                        Circle()
                            .fill(isListening ? Color.red : Color(hex: "0f3460"))
                            .frame(width: 80, height: 80)
                            .shadow(color: isListening ? .red.opacity(0.5) : .blue.opacity(0.3),
                                   radius: isListening ? 20 : 10)
                        
                        Image(systemName: isListening ? "stop.fill" : "mic.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                }
                .scaleEffect(isListening ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: isListening)
                .padding(.bottom, 50)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(openAIManager: openAIManager)
        }
        .onAppear {
            requestPermissions()
        }
    }
    
    private var statusColor: Color {
        if openAIManager.isProcessing {
            return .yellow
        } else if isListening {
            return .red
        } else if voiceManager.isSpeaking {
            return .green
        }
        return .gray
    }
    
    private var statusText: String {
        if openAIManager.isProcessing {
            return "Przetwarzanie..."
        } else if isListening {
            return "Słucham..."
        } else if voiceManager.isSpeaking {
            return "Mówię..."
        }
        return "Gotowy"
    }
    
    private func toggleListening() {
        if isListening {
            stopListening()
        } else {
            startListening()
        }
    }
    
    private func startListening() {
        isListening = true
        voiceManager.startRecording()
    }
    
    private func stopListening() {
        isListening = false
        voiceManager.stopRecording { transcript in
            if !transcript.isEmpty {
                processVoiceInput(transcript)
            }
        }
    }
    
    private func processVoiceInput(_ text: String) {
        Task {
            await openAIManager.sendMessage(text)
            
            if !openAIManager.responseText.isEmpty {
                voiceManager.speak(openAIManager.responseText)
            }
        }
    }
    
    private func requestPermissions() {
        // Request microphone permission
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("Microphone permission granted")
            }
        }
        
        // Request speech recognition permission
        SFSpeechRecognizer.requestAuthorization { status in
            if status == .authorized {
                print("Speech recognition authorized")
            }
        }
    }
}

// Message Bubble Component
struct MessageBubble: View {
    let text: String
    let isUser: Bool
    
    var body: some View {
        HStack {
            if isUser { Spacer() }
            
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.white)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isUser ? Color(hex: "0f3460") : Color(hex: "533483"))
                )
                .frame(maxWidth: 280, alignment: isUser ? .trailing : .leading)
            
            if !isUser { Spacer() }
        }
    }
}

// Color extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
