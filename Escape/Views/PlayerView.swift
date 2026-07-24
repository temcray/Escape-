//
//  PlayerView.swift
//  Escape
//
//  Created by Tatiana6mo on 6/30/26.
//

import SwiftUI
import AVKit
import CoreMedia

struct PlayerView: View {
    
    let song: JamendoSong
    let songs: [JamendoSong]
    
    @State private var currentTime: Double = 0
    @State private var duration: Double = 0
    
    @State private var isPlaying = false
    @State private var isShuffling = false
    @State private var isRepeating = false
    @State private var currentIndex = 0
    @State private var volume: Float = 0.5
    @State private var showVolumeWarning = false
    @State private var player: AVPlayer?
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    
    var currentSong: JamendoSong {
        guard !songs.isEmpty, currentIndex < songs.count else { return song }
        return songs[currentIndex]
    }
    
    var body: some View {
        ZStack {
            Color(isDarkMode ? Color.background : Color("oceanTeal"))
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // ALBUM IMAGE FROM URL
                AsyncImage(url: URL(string: song.albumImage)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.white.opacity(0.3)
                }
                .frame(width: 250, height: 250)
                .cornerRadius(20)
                .clipped()
                .padding(.top, 40)
                
                // SONG INFO
                Text(currentSong.title)
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text(currentSong.artist)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(currentSong.album)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.5))
                
                // PROGRESS BAR
                VStack(spacing: 4) {
                    
                    // SLIDER
                    Slider(value: $currentTime, in: 0...max(duration, 1), step: 0.1) { editing in
                        if !editing {
                            player?.seek(to: CMTime(seconds: currentTime, preferredTimescale: 600))
                        }
                    }
                    .accentColor(.white)
                    .padding(.horizontal, 30)
                    
                    //TIME STEPS
                    HStack {
                        Text(formatTime(currentTime))
                            .foregroundColor(.white.opacity(0.7))
                            .font(.caption)
                        
                        Spacer()
                        
                        Text(formatTime(duration))
                            .font(.caption)
                    }
                    .padding(.horizontal, 30)
                }
                
                // SHUFFLE AND REPEAT
                HStack(spacing: 40) {
                    Button(action: { isShuffling.toggle()}) {
                        Image(systemName: "shuffle")
                            .font(.title2)
                            .foregroundColor(isShuffling ? .yellow : .white)
                    }
                    
                    Spacer()
                    
                    Button(action: {isRepeating.toggle() }) {
                        Image(systemName: "repeat")
                            .font(.title2)
                            .foregroundColor(isRepeating ? .yellow : .white)
                    }
                }
                
                .padding(.horizontal, 40)
                
                // PREVIOUS PLAY/PAUSE NEXT
                HStack(spacing: 40) {
                    
                    Button(action: { previousSong() }) {
                        Image(systemName: "backward.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: { togglePlayback() }) {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: { nextSong() }) {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 35))
                            .foregroundColor(.white)
                    }
                }
                
                // VOLUME CONTROL
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "speaker.fill")
                            .foregroundColor(.white)
                        
                        Slider(value: $volume, in: 0...1, step: 0.01)
                            .accentColor(.white)
                            .onChange(of: volume) { newValue in
                                player?.volume = newValue
                                showVolumeWarning = newValue > 0.8
                            }
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 30)
                    
                    // VOLUME WARNING
                    if showVolumeWarning {
                        Text("⚠️ High volume may affect your hearing")
                            .foregroundColor(.yellow)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                }
                
                Spacer()
                
            }
        }
        .onAppear {
            setupIndex()
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
        
    }
    
    func setupIndex() {
        if let index = songs.firstIndex(where: { $0.id == song.id }) {
            currentIndex = index
        }
        loadAndPlay(song: currentSong)
    }
    
    func loadAndPlay(song: JamendoSong) {
        guard let url = URL(string: song.audioURL) else {
            print("x.fill. Invalid audio URL: \(song.audioURL)")
            return
        }
        player?.pause()
        player = AVPlayer(url: url)
        player?.volume = volume
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        player?.play()
        isPlaying = true
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { _ in
            if isRepeating {
                player?.seek(to: .zero)
                player?.play()
            } else {
                nextSong()
            }
        }
        
    }
    
    func togglePlayback() {
        guard let player = player else {
            print("x.fill player is nil")
            return
        }
        
        if isPlaying{
            player.pause()
        }else {
            player.play()
        }
        isPlaying.toggle()
    }
    
    func nextSong() {
        if isShuffling {
            currentIndex = Int.random(in: 0..<songs.count)
        } else {
            currentIndex = currentIndex < songs.count - 1 ? currentIndex + 1 : 0
        }
        loadAndPlay(song: currentSong)
    }
    
    func previousSong() {
        currentIndex = currentIndex > 0 ? currentIndex - 1 : songs.count - 1
        loadAndPlay(song: currentSong)
    }
    
    //FORMAT TIME
    func formatTime(_seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
    
    //START TRACKING TIME
    func startTimeObserver() {
        player? .addPeriodicTimeObserver()
        
        
        
    }
}
