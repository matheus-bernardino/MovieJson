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
    var moviePictures: [UIImage] = []
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
            if indexPath.row <= moviePictures.count {
                cell.poster.image = moviePictures[indexPath.row]
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        search.delegate = self
        perforAcssess(searchText: "")
    }

    func perforAcssess(searchText: String) {
        Repository.acssess.getInfo( completion: { result in
            switch result {
            case .success(let gotMovies):
                self.movies = gotMovies
                self.getMoviePictures(movies: self.movies)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }, searchText: searchText)
    }
    
    func getMoviePictures(movies: [Movie]) {
        Repository.acssess.getImages(completion: { result in
            switch result {
            case .success(let imagesGot):
                self.moviePictures = imagesGot
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }, movies: movies)
    }
}
