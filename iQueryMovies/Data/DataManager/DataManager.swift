//
//  DataManager.swift
//  iQueryMovies
//
//  Created by Yair Ivan Carreño Lizarazo on 12/9/17.
//  Copyright © 2017 Yair Ivan Carreño Lizarazo. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire

class DataManager {
    
    func getMovies(query: String, page: String) -> Observable<[Movie]> {
        return MovieAPI.getMovies(query: query, page: page)
    }
}
