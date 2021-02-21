//
//  LastSearchViewController.swift
//  MovieJson
//
//  Created by aluno001 on 14/02/21.
//

import UIKit

class LastSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var movies: [MovieState] = []
    var moviePictures: [UIImage] = []
    let controller = Controller()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieState") as? StoredTableViewCell else {
            return UITableViewCell()
        }
        cell.title.text = movies[indexPath.row].title
        cell.sinopse.text = movies[indexPath.row].sinopse
        if indexPath.row <= moviePictures.count {
            cell.poster.image = moviePictures[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    override func viewWillAppear(_ animated: Bool) {
        movies = controller.loadMovies()
        var poster_paths: [String?] = []
        for movie in self.movies {
            poster_paths.append(movie.poster_link)
        }
        getMoviePictures(poster_paths: poster_paths)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
