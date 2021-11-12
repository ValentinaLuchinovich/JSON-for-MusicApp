//
//  SearchResponse.swift
//  JSON for MusicApp
//
//  Created by Валентина Лучинович on 11.11.2021.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var collectionName: String?
    var artistName: String
    // изображение для трека
    var artworkUrl60: String?
}
