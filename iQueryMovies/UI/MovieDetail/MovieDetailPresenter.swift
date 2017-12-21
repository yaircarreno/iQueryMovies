//
//  MovieDetailPresenter.swift
//  iQueryMovies
//
//  Created by Yair Ivan Carreño Lizarazo on 12/9/17.
//  Copyright © 2017 Yair Ivan Carreño Lizarazo. All rights reserved.
//

import Foundation

class MovieDetailPresenter {
    
     private var movieDetailView: MovieDetailView?
    
    func attachView(movieDetailView: MovieDetailView) {
        self.movieDetailView = movieDetailView
        
        //Setup init configuration view
        self.movieDetailView?.setUpView()
    }
    
    func detachView() {
        self.movieDetailView = nil
    }
}
