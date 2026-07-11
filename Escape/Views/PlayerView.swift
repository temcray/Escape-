//
//  PlayerView.swift
//  Escape
//
//  Created by Tatiana6mo on 6/30/26.
//

import SwiftUI
import AVFoundation

struct PlayerView: View {
    
    let song: JamendoSong
    
    @State private var isPlaying = false
    @State private var volume: Float = 0.5
    @State private var showVolumeWarning: Bool = false
    
    @State private var player: AVAudioPlayer?
    
    var body: some View {
        ZStack {
            Color(red: 0.0, green: 0.6, blue: 0.6)
                .ignoresSafeArea()
            
            VStack(spacing: 30){
                
                //ALBUM PIC
                Image(song.albumImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 250)
                    .cornerRadius(20)
                    .clipped()
                    .padding(.top, 40)
                
                // SONG INFO
                Text(song.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text(song.artist)
                    .font(.headline)
                    .foregroundColor(.white .opacity(0.7))
                
                // PLAY/PAUSE
                Button(action: {
                    isPlaying.toggle()
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                }
                
                // VOLUME CONTRAL
                VStack(spacing: 8){
                    
                    HStack{
                        Image(systemName: "speaker.fill")
                            .foregroundColor(.white)
                        
                        Slider(value: $volume, in: 0...1, step: 0.01)
                            .accentColor(.white)
                            .onChange(of: volume) { newValue in
                                if newValue > 0.8 {
                                    showVolumeWarning = true
                                } else {
                                    showVolumeWarning = false
                                }
                            }
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 30)
                    
                    // VOLUME WARNING
                    if showVolumeWarning {
                        Text("High Volume may affect your hearing")
                            .foregroundColor(.yellow)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                }
                
                Spacer()
            }
        }
    }
    
}

#Preview{
    PlayerView(song: Song(title: "escapeImage 1", artist: "Artist One", albumImage: "beach", audioURL: ""))
    }

