//
//  MovieService.swift
//  MovieModel
//
//  Created by Nifantiev Leonid Dev on 02.03.2021.
//

import Moya

public class MovieService: MovieServiceInterface {
    private let provider: NetworkProvider<MovieTraget>
    
    public init(provider: NetworkProvider<MovieTraget>) {
        self.provider = provider
    }
    
    public func getPopularMovieList(page: Int, callback: @escaping ([Movie], Int) -> Void) {
        let target = MovieTraget.popular(page: page)
        provider.request(target: target) { (result) in
            switch result {
            case let .success(response):
                let response: MoviewResponse? = response.data.unbox()
                
                guard let movieResponse = response  else { callback([], 0); return  }
                
                callback(movieResponse.results, movieResponse.totalPages)
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    public func getMovieDetails(id: Int, callback: @escaping (Movie) -> Void) {
        let target = MovieTraget.movieDetails(id: id)
        provider.request(target: target) { (result) in
            switch result {
            case let .success(response):
                if let movie: Movie = response.data.unbox() {
                    callback(movie)
                } else {
                    debugPrint("impossible parse data")
                }
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    public func searchMovie(query: String, page: Int, callback: @escaping ([Movie], Int) -> Void) {
        let target = MovieTraget.search(query: query, page: page)
        provider.request(target: target) { (result) in
            switch result {
            case let .success(response):
                let response: MoviewResponse? = response.data.unbox()
                
                guard let movieResponse = response  else { callback([], 0); return  }
                
                callback(movieResponse.results, movieResponse.totalPages)
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}


public extension Data {
  func unbox<U: Decodable>() -> U? {
    do {
      let entity = try JSONDecoder().decode(U.self, from: self)
      return entity
    } catch let error {
      debugPrint(error)
      return nil
    }
  }
}
