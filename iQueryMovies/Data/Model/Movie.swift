//
//  Movie.swift
//  iQueryMovies
//
//  Created by Yair Ivan Carreño Lizarazo on 12/9/17.
//  Copyright © 2017 Yair Ivan Carreño Lizarazo. All rights reserved.
//

import Foundation

struct Movie {
    var title: String?
    var overview: String?
    var poster_path: String?
    
    init(title: String, overview: String, poster_path: String) {
        self.title = title
        self.overview = overview
        self.poster_path = poster_path
    }
}
