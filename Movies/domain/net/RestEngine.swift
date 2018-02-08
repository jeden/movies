//
//  RestEngine.swift
//  Movies
//
//  Created by Antonio Bello on 2/7/18.
//  Copyright © 2018 Elapsus. All rights reserved.
//

import Foundation

enum Result<DataType> {
    case success(data: DataType)
    case failure(error: Error)
}

enum RestError : Error {
    case invalidUrl
    case noData
    case invalidData
    case other(Error)
}

typealias MoviesCallback = (Result<[Movie]>) -> Void

private enum EndpointUrl : String {
    case movies = "https://s3.amazonaws.com/vodassets/showcase.json"
}

protocol RestEngine {
    func retrieveMovies(callback: @escaping MoviesCallback)
}

final class _RestEngine : RestEngine {
    private var session: URLSession { return URLSession.shared }

    func retrieveMovies(callback: @escaping MoviesCallback) {
        guard let url = URL(string: EndpointUrl.movies.rawValue) else {
            callback(Result.failure(error: RestError.invalidUrl))
            return
        }

        let request = URLRequest(url: url)
        let task = self.session.dataTask(with: request) { (data: Data? , response: URLResponse?, error: Error?) in
            guard error == nil else {
                callback(Result.failure(error: RestError.other(error!)))
                return
            }

//            guard let httpResponse = response as? HTTPURLResponse else {
//
//            }

            guard let data = data else {
                callback(Result.failure(error: RestError.noData))
                return
            }

            let jsonDecoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)

            do {
                let movies = try jsonDecoder.decode([Movie].self, from: data)
                callback(Result.success(data: movies))
            } catch {
                callback(Result.failure(error: RestError.invalidData))
                return
            }

        }

        task.resume()
    }
}
