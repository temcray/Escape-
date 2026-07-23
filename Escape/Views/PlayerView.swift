//
//  PlayerView.swift
//  Escape
//
//  Created by Tatiana6mo on 6/30/26.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    
    let song: JamendoSong
    let songs: [JamendoSong]
    
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
                
                // SHUFFLE AND REPEAT
                HStack(spacing: 40) {
                    Button(action: { isShuffling.toggle()}) {
                        Image(systemName: "shuffle")
                            .font(.title2)
                            .foregroundColor(isShuffling ? .yellow : .white)
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
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
    
    // SET UP THE PLAYER
    func setupPlayer() {
        guard let url = URL(string: song.audioURL) else {
            print("Invalid audio URL")
            return
        }
        player = AVPlayer(url: url)
        player?.volume = volume
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    // PLAY OR PAUSE
    func togglePlayback() {
        guard let player = player else { return }
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
}

