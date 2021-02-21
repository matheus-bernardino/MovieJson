//
//  ViewController.swift
//  MovieJson
//
//  Created by Matheus on 25/01/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var controller = Controller()
    var moviesState: [MovieState] = []
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
            cell.delegate = self
            cell.title.text = movies[indexPath.row].original_title
            for movie in self.moviesState {
                if movies[indexPath.row].original_title == movie.title {
                    cell.favButton.tintColor = .red
                    break
                }
            }
            print("index path row: \(indexPath.row)")
            print("movie picture count: \(moviePictures.count)")
            cell.sinopse.text = movies[indexPath.row].overview
            if indexPath.row < moviePictures.count {
                cell.poster.image = moviePictures[indexPath.row]
            }
            cell.movie = movies[indexPath.row]
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
        moviesState = controller.loadMovies()
    }

    func perforAcssess(searchText: String) {
        Repository.acssess.getInfo( completion: { result in
            switch result {
            case .success(let gotMovies):
                self.movies = gotMovies
                var poster_paths: [String?] = []
                for movie in self.movies {
                    poster_paths.append(movie.poster_path)
                }
                self.getMoviePictures(poster_paths: poster_paths)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }, searchText: searchText)
    }
    
    func getMoviePictures(poster_paths: [String?]) {
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
        }, poster_paths: poster_paths)
    }
}

extension ViewController: MovieCellDelegate {
    func removeFavMovie(movie: Movie) {
        controller.removeMovie(movie: movie)
    }
    
    func addFavMovie(movie: Movie) {
        controller.saveMovie(movie: movie)
    }
}
