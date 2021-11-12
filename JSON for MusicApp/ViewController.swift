//
//  ViewController.swift
//  JSON for MusicApp
//
//  Created by Валентина Лучинович on 11.11.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let networkDataFetcher = NetworkDataFetcher()
    // модель данных
    var searchResponce: SearchResponse? = nil
    // таймер для контроля времени между запросами в сеть
    private var timer: Timer?

    @IBOutlet weak var tableView: UITableView!
    // экземпляр строки поиска
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        
    }
    

    
    //  настройка Table View
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // добавляем к NavigationBar SearchBar
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        // меняем визуальное оформление searchBar
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.obscuresBackgroundDuringPresentation = false
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // колличество ячеек в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponce?.results.count ?? 0
    }
    
    // создаём ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = searchResponce?.results[indexPath.row]
        // выводим название трека
        cell.textLabel?.text = track?.trackName
        // выводим картинку
        let imageURL = URL(string: (track?.artworkUrl60)!)
        let data = try? Data(contentsOf: imageURL!)
        cell.imageView?.image = UIImage(data: data!)
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    // сохраняет и обновляет информацию вводимую в строку поиска
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // url с данными в формате JSON
        let urlString = "https://itunes.apple.com/search?term=jack+\(searchText)&limit=25"
        // таймер для контроля времени запроса
        // без него запрос в сеть идет при каждом назжатии, что съедает трафик
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchTracks(urlString: urlString) { (searchResponce) in
                guard let searchResponce = searchResponce else { return }
                self.searchResponce = searchResponce
                self.tableView.reloadData()
            }
        })
    }
}
