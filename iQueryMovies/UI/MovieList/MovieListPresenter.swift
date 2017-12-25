//
//  MovieListPresenter.swift
//  iQueryMovies
//
//  Created by Yair Ivan Carreño Lizarazo on 12/9/17.
//  Copyright © 2017 Yair Ivan Carreño Lizarazo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListPresenter {
    
    private var movieListView: MovieListView?
    private var dataManager: DataManager?
    private var pager: Pager?
    
    let disposeBag = DisposeBag()
    let pagerSubject = PublishSubject<Pager>()
    
    init() {}
    
    func attachView(movieListView: MovieListView) {
        self.movieListView = movieListView
        self.dataManager = DataManager()
        self.pager = Pager()
        
        //Setup init configuration view
        self.movieListView?.setUpView()
        
        //Setup subjects used to pager
        self.setUpPagerRx()
        
        //Load the first movie list
        self.loadMovies()
    }
    
    func detachView() {
        self.movieListView = nil
    }
    
    func loadSearch(control: ControlProperty<String>) {
        control
            .filter{ $0.count > 2 }
            .throttle(0.5, latest: true, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { query in Pager(query: query)}
            .do(onNext: { pager in self.pager = pager})
            .flatMapLatest { pager -> Observable<MovieResponse?> in
                if pager.getPage().isEmpty {
                    return .just(nil)
                }
                return self.sendRequestToApiObservable(pager: pager)!
                    .catchErrorJustReturn(nil)
            }.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] movieResponse in
                self.successfulResult(movieResponse: movieResponse!)
                }, onError: { error in
                    self.failResult(error: error)
            })
            .disposed(by: disposeBag)
    }
    
    func setUpPagerRx() {
        self.pagerSubject
            .flatMapLatest { pager -> Observable<MovieResponse?> in
                if pager.getPage().isEmpty {
                    return .just(nil)
                }
                return self.sendRequestToApiObservable(pager: pager)!
                    .catchErrorJustReturn(nil)
            }.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] movieResponse in
                self.successfulResult(movieResponse: movieResponse!)
                }, onError: { error in
                    self.failResult(error: error)
            })
            .disposed(by: disposeBag)
    }
    
    func loadMovies() {
        movieListView?.showLoader(show: true)
        pagerSubject.onNext(pager!)
    }
    
    func getPager() -> Pager {
        return self.pager!
    }
    
    private func sendRequestToApiObservable(pager: Pager) -> Observable<MovieResponse?>? {
        return self.dataManager?.getMovies(query: pager.getQuery(), page: pager.getPage())
    }
    
    private func successfulResult(movieResponse: MovieResponse) {
        if (movieResponse.totalResults! < Pager.limit) {
            self.pager?.setLastPage(isLastPage: true)
        }
        self.pager?.updateItemList(m: movieResponse.results!)
        self.movieListView?.addMovieList(movieList: (self.pager?.getItemList())!)
        self.movieListView?.showLoader(show: false)
    }
    
    private func failResult(error: Any) {
        print(error)
        self.movieListView?.showLoader(show: false)
    }
}
