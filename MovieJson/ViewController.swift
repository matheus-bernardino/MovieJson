//
//  ViewController.swift
//  MovieJson
//
//  Created by Matheus on 25/01/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var movies: [Movie] = []
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print(textField.text)
        if let text = textField.text {
            let textString = text.split(separator: " ").joined(separator: "+")
            perforAcssess(searchText: textString)
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if movies.isEmpty {
            return UITableViewCell()
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "movie") as? MovieCell else { return UITableViewCell() }
            cell.title.text = movies[indexPath.row].original_title
            cell.sinopse.text = movies[indexPath.row].overview
            DispatchQueue.global().async {
                do {
                    if let url = URL(string: "https://image.tmdb.org/t/p/w500") {
                        if let posterUrl = self.movies[indexPath.row].poster_path {
                            let novaUrl = url.appendingPathComponent(posterUrl)
                            let data = try Data(contentsOf: novaUrl)
                            DispatchQueue.main.async {
                                cell.poster.image = UIImage(data: data)
                            }
                        }
                    }
                } catch  {
                    print("Deu ruim na imagem")
                }
            }
            return cell
        }
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movie") as? MovieCell else { return UITableViewCell() }
//
//        cell.title.text = movies[indexPath.row].Title
//        cell.sinopse.text = movies[indexPath.row].Plot
//        cell.type.text = movies[indexPath.row].Genre
//
//        DispatchQueue.global().async {
//            do {
//                let url = self.movies[indexPath.row].Poster
//                let data = try Data(contentsOf: url)
//                DispatchQueue.main.async {
//                    cell.poster.image = UIImage(data: data)
//                }
//            } catch  {
//                print("Deu ruim na imagem")
//            }
//        }
//        return cell;
//        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
//    func loadMovies(resourse: String, type: String) {
//        if let path = Bundle.main.path(forResource: resourse, ofType: type) {
//            do {
//                let url = URL(fileURLWithPath: path)
//                let data = try Data(contentsOf: url, options: .mappedIfSafe)
//                
//                let decoder = JSONDecoder.init()
//                movies = try decoder.decode(Movies.self, from: data).movies
//            } catch  {
//                print("Deu ruim")
//            }
//        }
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        search.delegate = self
        perforAcssess(searchText: "")
//        loadMovies(resourse: "movies", type: "json")
        // Do any additional setup after loading the view.
    }

    func perforAcssess(searchText: String) {
        let acssess = Acssess()
//        acssess.delegate = self
        acssess.getInfo( completion: { result in
            switch result {
            case .success(let data):
                self.sendData(data: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }, searchText: searchText)
    }

    func sendData(data: Data) {
        print("Protocol")
        if let information = String(data: data, encoding: .utf8) {
            print(information)
        }
        do {
            let decoder = JSONDecoder.init()
            
            movies = try decoder.decode(Movies.self, from: data).results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch  {
            print("Deu ruim")
        }
    }
}
