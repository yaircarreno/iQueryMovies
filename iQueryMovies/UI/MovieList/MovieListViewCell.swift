//
//  MovieListViewCell.swift
//  iQueryMovies
//
//  Created by Yair Ivan Carreño Lizarazo on 12/10/17.
//  Copyright © 2017 Yair Ivan Carreño Lizarazo. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieListViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    func configure(for movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        
        if movie.poster_path != nil {
            let url = URL(string: MovieAPI.baseImageURLString + movie.poster_path!)!
            posterImageView.af_setImage(withURL: url)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.af_cancelImageRequest()
        posterImageView.image = nil
    }
}
