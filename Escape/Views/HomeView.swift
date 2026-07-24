//
//  HomeView.swift
//  Escape
//
//  Created by Tatiana6mo on 6/30/26.
//

import SwiftUI
import Speech
import AVFoundation

struct SearchView: View {
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @State private var searchText = ""
    @State private var isListening = false
    @State private var jamendoService = JamendoService()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let audioEngine = AVAudioEngine()
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    
    var body: some View {
        ZStack {
            Color(isDarkMode ? .background : Color("oceanTeal"))
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Text("Search")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                // SEARCH BAR AND MIC
                HStack {
                    TextField("Search songs or artists...", text: $searchText)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .onSubmit {
                            jamendoService.fetchSongs(search: searchText)
                        }
                    
                    // VOICE BUTTON
                    Button(action: {
                        if isListening {
                            stopListening()
                        } else {
                            startListening()
                        }
                    }) {
                        Image(systemName: isListening ? "mic.fill" : "mic")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(isDarkMode ? Color.white.opacity(0.2) : Color.white.opacity(0.3))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                
                // LISTENING INDICATOR
                if isListening {
                    Text("Listening...")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                
                // SEARCH RESULTS
                if jamendoService.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                        .padding(.top, 40)
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(jamendoService.songs) { song in
                                HStack {
                                    AsyncImage(url: URL(string: song.albumImage)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Color.white.opacity(0.3)
                                    }
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                                    
                                    VStack(alignment: .leading) {
                                        Text(song.title)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        Text(song.artist)
                                            .foregroundColor(.white.opacity(0.7))
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 10)
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            requestPermissions()
        }
    }
    
    // REQUEST MIC AND SPEECH PERMISSIONS
    func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    print("Speech recognition authorized")
                }
            }
        }
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    print("Microphone authorized")
                }
            }
        }
    }
    
    // START LISTENING
    func startListening() {
        guard let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable else { return }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else { return }
        
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        guard recordingFormat.sampleRate > 0,
              recordingFormat.channelCount > 0 else {
            print("Invalid microphone format: ")
            stopListening()
            return
        }
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
        
        isListening = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                searchText = result.bestTranscription.formattedString
                jamendoService.fetchSongs(search: searchText)
            }
            if error != nil {
                stopListening()
            }
        }
    }
    
    // STOP LISTENING
    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
        isListening = false
    }
}






struct HomeView: View {
    
    @State private var jamendoService = JamendoService()
    @State private var isGrid = true
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                
             
                VStack {
                    
                    // TOGGLE GRID
                    HStack {
                        Spacer()
//                        Button(action: {
//                            isGrid.toggle()
//                        }) {
//                            Image(systemName: isGrid ? "list.bullet" : "square.grid.2x2")
//                                .foregroundColor(.white)
//                                .font(.title2)
//                        }
//                        .padding(.trailing, 20)
                    }
                    
                    // Loading indicator
                    if jamendoService.isLoading {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(2)
                        Spacer()
                        
                    } else if isGrid {
                        // GRID VIEW
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(jamendoService.songs) { song in
                                    SongCardView(song: song, songs: jamendoService.songs)
                                }
                            }
                            .padding()
                        }
                    } else {
                        // LIST VIEW
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(jamendoService.songs) { song in
                                    SongCardView(song: song, songs: jamendoService.songs)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("ESCAPE")
                        .font(appFont(.largeTitle).bold())
                        .foregroundColor(.white)
                        .padding(.top, 80)
                }
                
                ToolbarItem(placement:.topBarTrailing) {
                    Button(action: {
                        isGrid.toggle()
                    }) {
                        Image(systemName: isGrid ? "list.bullet" : "square.grid.2x2")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    //.padding(.trailing, 20)
                }
            }
            //.navigationTitle("Escape")
            //.navigationBarTitleDisplayMode(.large)
            .onAppear {
                jamendoService.fetchSongs()
            }
        }
    }
}

// SONG CARD

struct SongCardView: View {
    
    let song: JamendoSong
    let songs: [JamendoSong]
    
    var body: some View {
        NavigationLink(destination: PlayerView(song: song, songs: songs)) {
            VStack {
                //AsyncImage when they come off web site
                AsyncImage(url: URL(string:song.albumImage)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(12)
                            .clipped()
                    }
                }
                
                Text(song.title)
                    .foregroundColor(.white)
                    .font(.headline)
                
                Text(song.artist)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.subheadline)
            }
        }
    }
}
