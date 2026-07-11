//
//  Item.swift
//  Escape
//
//  Created by Tatiana6mo on 6/30/26.
//

import SwiftData

@Model
class Song {
    var title: String
    var artist: String
    var albumImage: String
    var audioURL: String
    var isFavorite: Bool
    
    init(title: String, artist: String, albumImage: String, audioURL: String, isFavorite: Bool = false) {
        self.title = title
        self.artist = artist
        self.albumImage = albumImage
        self.audioURL = audioURL
        self.isFavorite = false
    }
}

