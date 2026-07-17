//
//  JamendoService.swift
//  Escape
//
//  Created by Tatiana6mo on 7/11/26.
//

import Foundation
import Observation

@Observable
class JamendoService {
    
    var songs: [JamendoSong] = []
    var isLoading = false
    
    let clientID = "8410d329"
    
    func fetchSongs(search: String = "pop") {
        isLoading = true
        
        let urlString = "https://api.jamendo.com/v3.0/tracks/?client_id=\(clientID)&format=json&limit=20&search=\(search)&imagesize=300&include=musicinfo"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(JamendoResponse.self, from: data)
                DispatchQueue.main.async {
                    self.songs = decoded.results.map { track in
                        JamendoSong(
                            id: track.id,
                            title: track.name,
                            artist: track.artist_name,
                            album: track.album_name,
                            albumImage: track.album_image,
                            audioURL: track.audio
                        )
                    }
                    self.isLoading = false
                }
            } catch {
                print("Jamendo error: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }
}

struct JamendoResponse: Codable {
    let results: [JamendoTrack]
}

struct JamendoTrack: Codable {
    let id: String
    let name: String
    let artist_name: String
    let album_name: String
    let album_image: String
    let audio: String
}
