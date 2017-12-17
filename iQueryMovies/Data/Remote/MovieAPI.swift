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

struct MovieAPI {
    
    static let apiKey = "73d93a8edf384634a2c561159294fcf0"
    static let baseURLString = "http://api.themoviedb.org/3/search/movie"
    static let baseImageURLString = "http://image.tmdb.org/t/p/w154"
    
    static let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
    
    static func getMovies(query: String, page: String) -> Observable<[Movie]> {
        return
            json(.get, baseURLString, parameters: ["query": query, "page": page, "api_key": apiKey])
            .map{ result in  toMovieArray(fromJSON: result) }
            .flatMap {
                arrayMovies in Observable.from(arrayMovies)
                    .map{ movieJson in movie(fromJSON: movieJson)! }
            }.toArray()
            .subscribeOn(globalScheduler)
    }
    
    private static func toMovieArray(fromJSON jsonResult: Any) -> [[String:Any]] {
        let jsonDictionary = jsonResult as? [AnyHashable:Any]
        let moviesArray = jsonDictionary!["results"] as? [[String:Any]]
        return moviesArray!
    }
    
    private static func movie(fromJSON json: [String : Any]) -> Movie? {
        guard
            let title = json["original_title"] as? String,
            let overview = json["overview"] as? String else {
                // Don't have enough information to construct a movie
                return nil
        }
        let poster_path = nullToNil(value: json["poster_path"] as AnyObject)
        return Movie(title: title, overview: overview, poster_path: poster_path!)
    }
    
    private static func nullToNil(value : AnyObject?) -> String? {
        if value is NSNull {
            return "/7k9db7pJyTaVbz3G4eshGltivR1.jpg"
        } else {
            return value as? String
        }
    }
}
