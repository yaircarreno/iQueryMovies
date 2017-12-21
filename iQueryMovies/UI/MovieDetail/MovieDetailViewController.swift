//
//  MovieDetailViewController.swift
//  iQueryMovies
//
//  Created by Yair Ivan Carreño Lizarazo on 12/9/17.
//  Copyright © 2017 Yair Ivan Carreño Lizarazo. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var textTitleLabel: UILabel!
    @IBOutlet weak var textOverviewLabel: UILabel!
    @IBOutlet weak var textReleaseLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    var selectedMovie: Movie?
    let movieDetailPresenter = MovieDetailPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieDetailPresenter.attachView(movieDetailView: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        movieDetailPresenter.detachView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MovieDetailViewController: MovieDetailView {
    func setUpView() {
        guard let movie = selectedMovie else {
            return
        }
        if let title = movie.title {
            textTitleLabel.text = title
        }
        if let overview = movie.overview {
            textOverviewLabel.text = overview
        }
        if let release = movie.release_date {
            textReleaseLabel.text = release
        }
        let url = URL(string: MovieAPI.baseImageURLString + movie.poster_path!)!
        posterImage.af_setImage(withURL: url)
    }
}
