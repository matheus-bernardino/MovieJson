//
//  MovieCell.swift
//  MovieJson
//
//  Created by Matheus on 25/01/21.
//

import UIKit

protocol MovieCellDelegate: class {
    func addFavMovie(movie: Movie)
    func removeFavMovie(movie: Movie)
}

class MovieCell: UITableViewCell {
    var delegate: MovieCellDelegate?
    var movie: Movie?
    
    @IBAction func addFav(_ sender: UIButton) {
        if sender.tintColor == .red {
            sender.tintColor = .blue
            if let movie = movie {
                delegate?.removeFavMovie(movie: movie)
            }
        } else {
            sender.tintColor = .red
            if let movie = movie {
                delegate?.addFavMovie(movie: movie)
            }
        }
    }
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var sinopse: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
