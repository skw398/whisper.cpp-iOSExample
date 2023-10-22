import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject var whisperState = WhisperState()
    @State private var showPicker = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Select WAV File") {
                    showPicker = true
                }
                .sheet(isPresented: $showPicker) {
                    WavePicker(onPick: { url in
                        showPicker = false
                        whisperState.transcribeSelectedWave(url)
                    }, onCancel: {
                        showPicker = false
                    })
                }
                
                HStack {
                    Button("Transcribe sample", action: {
                        Task {
                            await whisperState.transcribeSample()
                        }
                    })
                    .buttonStyle(.bordered)
                    .disabled(!whisperState.canTranscribe)
                    
                    Button(whisperState.isRecording ? "Stop recording" : "Start recording", action: {
                        Task {
                            await whisperState.toggleRecord()
                        }
                    })
                    .buttonStyle(.bordered)
                    .disabled(!whisperState.canTranscribe)
                }
                
                ScrollView {
                    Text(verbatim: whisperState.messageLog)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle("Whisper SwiftUI Demo")
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
