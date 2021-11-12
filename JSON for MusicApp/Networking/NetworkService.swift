//
//  NetworkService.swift
//  JSON for MusicApp
//
//  Created by Валентина Лучинович on 12.11.2021.
//

import Foundation

class NetworkService {
    
    // функция выполняет сетевой запрос для получения данных о композициях
    func request(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask (with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion (.failure(error))
                    return
                }
                //парсинг данных из сети
                guard let data = data else { return }
                completion(.success(data))
            }
        } .resume()
    }
}
