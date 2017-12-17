//
//  Pager.swift
//  iQueryMovies
//
//  Created by Yair Ivan Carreño Lizarazo on 12/13/17.
//  Copyright © 2017 Yair Ivan Carreño Lizarazo. All rights reserved.
//

import Foundation

struct Pager {
    var page: Int
    var query: String
    var movieList: [Movie]
    static var LIMIT: String = "10"
    
    init() {
        self.page = 1
        self.movieList = []
        self.query = "club"
    }
    
    mutating func updateItemList(m movies: [Movie]) {
        self.movieList.insert(contentsOf: movies, at: movieList.count)
        self.page += 1
    }
    
    func getItemList() -> [Movie] {
        return self.movieList
    }
    
    func getItemCount() -> Int {
        return self.movieList.count
    }
    
    func getPage() -> String {
        return String(self.page)
    }
}
