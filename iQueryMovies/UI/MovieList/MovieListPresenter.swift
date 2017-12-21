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
            .flatMapLatest { pager -> Observable<[Movie]> in
                if pager.getPage().isEmpty {
                    return .just([])
                }
                return self.sendRequestToApiObservable(pager: pager)!
                    .catchErrorJustReturn([])
            }.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] movieList in
                self.successfulResult(movieList: movieList)
                }, onError: { error in
                    self.failResult(error: error)
            })
            .disposed(by: disposeBag)
    }
    
    func setUpPagerRx() {
        self.pagerSubject
            .flatMapLatest { pager -> Observable<[Movie]> in
                if pager.getPage().isEmpty {
                    return .just([])
                }
                return self.sendRequestToApiObservable(pager: pager)!
                    .catchErrorJustReturn([])
            }.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] movieList in
                self.successfulResult(movieList: movieList)
                }, onError: { error in
                    self.failResult(error: error)
            })
            .disposed(by: disposeBag)
    }
    
    func loadMovies() {
        movieListView?.showLoader(show: true)
        pagerSubject.onNext(pager!)
    }
    
    func getMovieCount() -> Int {
        return pager!.getItemCount()
    }
    
    private func sendRequestToApiObservable(pager: Pager) -> Observable<[Movie]>? {
        return self.dataManager?.getMovies(query: pager.query, page: pager.getPage())
    }
    
    private func successfulResult(movieList: [Movie]) {
        self.pager?.updateItemList(m: movieList)
        self.movieListView?.addMovieList(movieList: (self.pager?.getItemList())!)
        self.movieListView?.showLoader(show: false)
        self.movieListView?.hideKeyBoard(hide: true)
    }
    
    private func failResult(error: Any) {
        print(error)
        self.movieListView?.showLoader(show: false)
    }
}
