//
//  MovieCell.swift
//  Movies
//
//  Created by Antonio Bello on 2/7/18.
//  Copyright © 2018 Elapsus. All rights reserved.
//

import UIKit
import SDWebImage

protocol MovieCellDelegate {
    func movieCellDidTapReadMore(_ cell: MovieCell)
    func movieCellDidTapStar(_ cell: MovieCell)
}

class MovieCell: UITableViewCell {
    fileprivate static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    static let cellId = "movie-cell"
    private var delegate: MovieCellDelegate!
    private(set) var indexPath: IndexPath!

    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var descriptionLabel: UILabel!
    @IBOutlet weak fileprivate var readMoreButton: UIButton!
    @IBOutlet weak fileprivate var movieImage: UIImageView!
    @IBOutlet weak fileprivate var releaseDate: UILabel!
    @IBOutlet weak fileprivate var starButton: UIButton!

    fileprivate var movie: Movie! { didSet {
        self.titleLabel.text = self.movie.headline
        self.descriptionLabel.text = self.movie.synopsis
        self.releaseDate.text = ExpandedMovieCell.dateFormatter.string(from: self.movie.releaseDate)

        // TODO: Take care of recycling and asynchronous images load

        if let _url = self.movie.imageUrl, let url = URL(string: _url) {
            self.movieImage.sd_setImage(with: url)
        } else {
            self.movieImage.image = nil
        }

        self.starButton.setImage(self.movie.starred ? #imageLiteral(resourceName: "star-on") : #imageLiteral(resourceName: "star-off"), for: .normal)
    }}

    override func prepareForReuse() {
        super.prepareForReuse()

        self.titleLabel.text = ""
        self.descriptionLabel.text = ""
        self.indexPath = nil
        self.delegate = nil
    }

    func configure(with movie: Movie, indexPath: IndexPath, delegate: MovieCellDelegate) {
        self.movie = movie
        self.delegate = delegate
        self.indexPath = indexPath
    }

    @IBAction func didTapReadMore() {
        self.delegate.movieCellDidTapReadMore(self)
    }

    @IBAction func didTapStar() {
        self.delegate.movieCellDidTapStar(self)
    }
}

final class ExpandedMovieCell : MovieCell {
    static let expandedCellId = "expanded-movie-cell"
}
