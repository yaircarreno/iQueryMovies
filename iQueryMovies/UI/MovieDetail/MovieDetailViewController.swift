//
//  MovieDetailViewController.swift
//  iQueryMovies
//
//  Created by Yair Ivan Carreño Lizarazo on 12/9/17.
//  Copyright © 2017 Yair Ivan Carreño Lizarazo. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var textOverviewLabel: UILabel!
    
    var selectedMovie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setUp(){
        guard let movie = selectedMovie else {
            return
        }
        if let overview = movie.overview { textOverviewLabel.text = overview }
    }
}
