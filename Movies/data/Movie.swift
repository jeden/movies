//
//  Movie.swift
//  Movies
//
//  Created by Antonio Bello on 2/7/18.
//  Copyright © 2018 Elapsus. All rights reserved.
//

import Foundation

struct Movie : Decodable {
    struct CardImage : Decodable {
        var url : String
        var h: Int
        var w: Int
    }

    struct ViewingWindow : Decodable {
        var startDate: Date
    }

    var id: String
    var headline: String
    var cardImages: [CardImage]
    var synopsis: String
    //var viewingWindow: ViewingWindow

    var releaseDate: Date { return Date() }
    var imageUrl: String? { return self.cardImages.first?.url }
}
