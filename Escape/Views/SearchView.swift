//
//  SearchView.swift
//  Escape
//
//  Created by Tatiana6mo on 6/30/26.
//

import SwiftUI
import Speech

struct SearchView: View {
    
    @State private var searchText = ""
    @State private var isListening = false
    
    private let speechRecognizer = SFSpeechRecognizer()
    private let audioEngine = AVAudioEngine()
    
    var body: some View {
        ZStack {
            Color(red: 0.0, green: 0.6, blue: 0.6)
                .ignoresSafeArea()
            
            
            VStack(spacing: 20) {
                
                Text("Search")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                
                // SEARCH BAR AND MIC
                HStack {
                    TextField("Search songs or artists...", text: $searchText)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    
                    
                    // VOICE ACTION
                    Button(action: {
                        isListening.toggle()
                        
                    }) {
                        Image(systemName: isListening ? "mic.fill" : "mic")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                
                //APP LISTENING
                if isListening {
                    Text("Listening...")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                
                Spacer()
            }
        }
    }

    
}

#Preview {
    SearchView()
}




