//
//  MovieListPresenter.swift
//  iQueryMovies
//
//  Created by Yair Ivan Carreño Lizarazo on 12/9/17.
//  Copyright © 2017 Yair Ivan Carreño Lizarazo. All rights reserved.
//

import Foundation
import RxSwift

class MovieListPresenter {
    
    private var movieListView: MovieListView?
    private var dataManager: DataManager?
    private var pager: Pager?
    
    let disposeBag = DisposeBag()
    
    init() {}
    
    func attachView(movieListView: MovieListView) {
        self.movieListView = movieListView
        self.dataManager = DataManager()
        self.pager = Pager()
        
        loadMovies()
    }
    
    func detachView() {
        self.movieListView = nil
    }
    
    func loadMovies() {
        movieListView?.showLoader(show: true)
        self.dataManager?.getMovies(query: "club", page: pager!.getPage())
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] movieList in
                self.pager?.updateItemList(m: movieList)
                self.movieListView?.addMovieList(movieList: (self.pager?.getItemList())!)
                self.movieListView?.showLoader(show: false)
                }, onError: { error in
                    print(error)
                    self.movieListView?.showLoader(show: false)
            })
            .disposed(by: disposeBag)
    }
    
    func getMovieCount() -> Int {
        return pager!.getItemCount()
    }
}
