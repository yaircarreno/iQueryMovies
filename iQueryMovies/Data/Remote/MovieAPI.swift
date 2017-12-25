//
//  MovieAPI.swift
//  iQueryMovies
//
//  Created by Yair Ivan Carreño Lizarazo on 12/9/17.
//  Copyright © 2017 Yair Ivan Carreño Lizarazo. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import ObjectMapper

struct MovieAPI {
    
    static let apiKey = "73d93a8edf384634a2c561159294fcf0"
    static let baseURLString = "http://api.themoviedb.org/3/search/movie"
    static let baseImageURLString = "http://image.tmdb.org/t/p/w154"
    
    static let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
    
    static func getMovies(query: String, page: String) -> Observable<MovieResponse?> {
        return
            json(.get, baseURLString, parameters: ["query": query, "page": page, "api_key": apiKey])
                .map{ result in toMapper(fromJSON: result)}
                .subscribeOn(globalScheduler)
    }
    
    private static func toMapper(fromJSON jsonResult: Any) -> MovieResponse? {
        guard let movieResponse = Mapper<MovieResponse>().map(JSONObject: jsonResult) else {
            return nil
        }
        return movieResponse
    }
}
