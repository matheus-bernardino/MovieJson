//
//  ViewController.swift
//  MovieJson
//
//  Created by Matheus on 25/01/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var movies: [Movie] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movie") as? MovieCell else { return UITableViewCell() }
    
        cell.title.text = movies[indexPath.row].Title
        cell.sinopse.text = movies[indexPath.row].Plot
        cell.type.text = movies[indexPath.row].Genre
        
        DispatchQueue.global().async {
            do {
                let url = self.movies[indexPath.row].Poster
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    cell.poster.image = UIImage(data: data)
                }
            } catch  {
                print("Deu ruim na imagem")
            }
        }
        return cell;
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func loadMovies(resourse: String, type: String) {
        if let path = Bundle.main.path(forResource: resourse, ofType: type) {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                
                let decoder = JSONDecoder.init()
                movies = try decoder.decode(Movies.self, from: data).movies
            } catch  {
                print("Deu ruim")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadMovies(resourse: "movies", type: "json")
        // Do any additional setup after loading the view.
    }


}

