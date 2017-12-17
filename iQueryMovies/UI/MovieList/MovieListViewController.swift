//
//  MovieListViewController.swift
//  iQueryMovies
//
//  Created by Yair Ivan Carreño Lizarazo on 12/9/17.
//  Copyright © 2017 Yair Ivan Carreño Lizarazo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let moviesTable: Variable<[Movie]> = Variable([])
    let movieListPresenter = MovieListPresenter()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieListPresenter.attachView(movieListView: self)
        bindTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieListPresenter.detachView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func bindTableView() {
        
        moviesTable.asObservable()
            .bind(to: tableView.rx.items) {
                (tableView: UITableView, index: Int, movie: Movie) in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: "movieListViewCell", for: indexPath) as! MovieListViewCell
                cell.configure(for: movie)
                return cell }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(Movie.self)
            .subscribe(onNext: { model in
                print("\(model) was selected")
            })
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { [unowned self] cellInfo in
                let (_, indexPath) = cellInfo
                if indexPath.row + 1 == self.movieListPresenter.getMovieCount() {
                    self.movieListPresenter.loadMovies()
                }
            }).disposed(by: disposeBag)
    }
}

extension MovieListViewController: MovieListView {
    func addMovieList(movieList: [Movie]) {
        print("Total de items de lista: \(movieList.count)")
        moviesTable.value = movieList
        tableView.reloadData()
    }
}
