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
    
    let disposeBag = DisposeBag()
    let movieListPresenter = MovieListPresenter()
    
    private let moviesTable: Variable<[Movie]> = Variable([])
    private var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieListPresenter.attachView(movieListView: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        movieListPresenter.detachView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func bindTableView() {
        // Bind table to react to movie list.
        moviesTable.asObservable()
            .bind(to: tableView.rx.items) {
                (tableView: UITableView, index: Int, movie: Movie) in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: "movieListViewCell", for: indexPath) as! MovieListViewCell
                cell.configure(for: movie)
                return cell }
            .disposed(by: disposeBag)
        
        // Select item from the table
        tableView.rx
            .modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movie in
                self?.performSegue(withIdentifier: "showDetail", sender: movie)
            })
            .disposed(by: disposeBag)
        
        // Reach bottom of movie list
        tableView.rx.willDisplayCell
            .subscribe(onNext: { [unowned self] cellInfo in
                let (_, indexPath) = cellInfo
                if indexPath.row + 1 == self.movieListPresenter.getMovieCount() {
                    self.movieListPresenter.loadMovies()
                }
            }).disposed(by: disposeBag)
    }
    
    func bindSearchView() {
        movieListPresenter.loadSearch(control: searchBar.rx.text.orEmpty)
    }
    
    func setUpLoader() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetail") {
            let movieDetailViewController = segue.destination as! MovieDetailViewController
            let movie = sender as! Movie
            movieDetailViewController.selectedMovie = movie
        }
    }
}

extension MovieListViewController: MovieListView {
    
    func setUpView() {
        setUpLoader()
        bindTableView()
        bindSearchView()
    }
    
    func addMovieList(movieList: [Movie]) {
        print("Total de items de lista: \(movieList.count)")
        moviesTable.value = movieList
        tableView.reloadData()
    }
    
    func showLoader(show: Bool) {
        if (show) {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
