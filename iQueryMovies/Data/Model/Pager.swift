//
//  Pager.swift
//  iQueryMovies
//
//  Created by Yair Ivan Carreño Lizarazo on 12/13/17.
//  Copyright © 2017 Yair Ivan Carreño Lizarazo. All rights reserved.
//

import Foundation

struct Pager {
    private var lastPage: Bool
    private var page: Int
    private var query: String
    private var movieList: [Movie]
    static let limit: Int = 20
    
    init() {
        self.lastPage = false
        self.page = 1
        self.movieList = []
        self.query = "batman"
    }
    
    init(query: String) {
        self.init()
        self.query = query
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
    
    func getLastPage() -> Bool {
        return self.lastPage
    }
    
    mutating func setLastPage(isLastPage: Bool) -> Void {
        self.lastPage = isLastPage
    }
    
    func getPage() -> String {
        return String(self.page)
    }
    
    func getQuery() -> String {
        return self.query
    }
}
