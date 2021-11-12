//
//  NetworkDataFetcher.swift
//  JSON for MusicApp
//
//  Created by Валентина Лучинович on 12.11.2021.
//

import Foundation

class NetworkDataFetcher {
    
    let networkService = NetworkService()
    
    //парсинг данных
    func fetchTracks(urlString: String, response: @escaping (SearchResponse?) -> Void) {
        networkService.request(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let tracks = try JSONDecoder().decode(SearchResponse.self, from: data)
                    response(tracks)
                } catch let jsonError{
                    print("Faield to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
}
