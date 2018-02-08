//
//  MoviesController.swift
//  Movies
//
//  Created by Antonio Bello on 2/7/18.
//  Copyright © 2018 Elapsus. All rights reserved.
//

import UIKit

final class MoviesController : UITableViewController {
    private var expandedMovieIndex: Int?
    private let restEngine: RestEngine = _RestEngine()
    private var movies: [Movie] = [] { didSet {
        guard let tableView = self.tableView else { return }
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }}

    override func viewDidLoad() {
        super.viewDidLoad()

        self.restEngine.retrieveMovies { result in
            switch result {
            case .failure(let error) :
                // TODO: Handle error
                print(error)

            case.success(let movies):
                self.movies = movies
            }
        }
    }

    // Note: implemented an in place raw sort. A better  solution is to keep the original unsorted list
    // and give the ability to sort ascending/descending, as well as return to the unsorted list
    @IBAction func didTapSort(_ sender: Any) {
        self.movies.sort { $0.releaseDate > $1.releaseDate }
        self.tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension MoviesController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isExpanded = indexPath.row == self.expandedMovieIndex
        let cellId = isExpanded ? ExpandedMovieCell.expandedCellId : MovieCell.cellId


        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MovieCell else { fatalError("Unable to dequeue cell") }
        // TODO: guard to check that the row exists
        let movie = self.movies[indexPath.row]
        cell.configure(with: movie, indexPath: indexPath, delegate: self)
        return cell
    }
}

extension MoviesController : MovieCellDelegate {
    func movieCellDidTapStar(_ cell: MovieCell) {
        let index = cell.indexPath.row
        self.movies[index].starred = !self.movies[index].starred
        cell.configure(with: self.movies[index], indexPath: cell.indexPath, delegate: self)
    }

    func movieCellDidTapReadMore(_ cell: MovieCell) {
        if let expandedMovieIndex = self.expandedMovieIndex {
            let indexPath = IndexPath(row: expandedMovieIndex, section: 0)
            self.expandedMovieIndex = nil
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        self.expandedMovieIndex = cell.indexPath.row
        self.tableView.reloadRows(at: [cell.indexPath], with: .automatic)
    }
}
