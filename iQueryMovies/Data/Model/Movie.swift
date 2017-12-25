//
//  Movie.swift
//  iQueryMovies
//
//  Created by Yair Ivan Carreño Lizarazo on 12/9/17.
//  Copyright © 2017 Yair Ivan Carreño Lizarazo. All rights reserved.
//

import Foundation
import ObjectMapper

struct MovieResponse: Mappable {
    var totalPages: Int?
    var totalResults:Int?
    var results: [Movie]?
    
    init?(map: Map){
    }
    
    mutating func mapping(map: Map) {
        totalPages <- map["total_pages"]
        totalResults <- map["total_results"]
        results <- map["results"]
    }
}

struct Movie: Mappable {
    var title: String?
    var overview: String?
    var poster_path: String?
    var release_date: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        title <- map["original_title"]
        overview <- map["overview"]
        poster_path <- map["poster_path"]
        release_date <- map["release_date"]
    }
}
