//
//  HomeView.swift
//  Escape
//
//  Created by Tatiana6mo on 6/30/26.
//

import SwiftUI

struct HomeView: View {
    
    @State private var isGrid = true
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    // Temp placeholder until Jamendo
    let songs = [
        JamendoSong(id: "1", title: "Ocean Breeze", artist: "Artist One", album: "Album One", albumImage: "escapeImage 1", audioURL: ""),
        JamendoSong(id: "2", title: "City Lights", artist: "Artist Two", album: "Album Two", albumImage: "escapeImage", audioURL: ""),
        JamendoSong(id: "3", title: "Morning Ride", artist: "Artist Three", album: "Album Three", albumImage: "escapeImage2", audioURL: "")
    ]
    var body: some View {
        NavigationView {
            ZStack {
                
                Color(red: 0.0, green: 0.6, blue: 0.6)
                    .ignoresSafeArea()
                
                VStack {
                    
                    // TOGGLE GRID
                    HStack {
                        Spacer()
                        Button(action: {
                            isGrid.toggle()
                        }) {
                            Image(systemName: isGrid ? "list.bullet" : "square.grid")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        .padding(.trailing, 20)
                    }
                    
                    if isGrid {
                        // GRID VIEW
                        ScrollView{
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(songs, id: \.title) { song in
                                    SongCardView(song: song)
                                    
                                }
                            }
                            .padding()
                            
                        }
                    } else {
                        // LIST VIEW
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(songs, id: \.title) { song in
                                    SongCardView(song: song)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Escape")
            .navigationBarTitleDisplayMode(.large)
        }
        
    }
}

// SONG CARD

struct SongCardView: View {
    
    let song: JamendoSong
    
    var body: some View {
        NavigationLink(destination: PlayerView(song: song)) {
            VStack {
                Image(song.albumImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .cornerRadius(12)
                    .clipped()
                
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
