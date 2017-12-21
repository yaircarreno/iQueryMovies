//
//  MovieListView.swift
//  iQueryMovies
//
//  Created by Yair Ivan Carreño Lizarazo on 12/9/17.
//  Copyright © 2017 Yair Ivan Carreño Lizarazo. All rights reserved.
//

import Foundation

protocol MovieListView {
    func setUpView()
    func addMovieList(movieList: [Movie])
    func showLoader(show: Bool)
    func hideKeyBoard(hide: Bool)
}
