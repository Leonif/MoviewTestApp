//
//  MovieService.swift
//  MovieModel
//
//  Created by Nifantiev Leonid Dev on 02.03.2021.
//

import Moya
import CoreData

public class MovieService: MovieServiceInterface {
    private let provider: NetworkProvider<MovieTraget>
    private let persistanceProvider: PitchPersistenceProviderInterface
    
    public init(provider: NetworkProvider<MovieTraget>, persistanceProvider: PitchPersistenceProviderInterface) {
        self.provider = provider
        self.persistanceProvider = persistanceProvider
    }
    
    public func getPopularMovieList(page: Int, callback: @escaping ([Movie], Int) -> Void) {
        let target = MovieTraget.popular(page: page)
        provider.request(target: target) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                let response: MoviewResponse? = response.data.unbox()
                
                guard let movieResponse = response  else { callback([], 0); return  }
                
                let movieList = movieResponse.results
                
                callback(movieList, movieResponse.totalPages)
                
                self.saveMovieList(list: movieList)

            case let .failure(error):
                debugPrint(error.localizedDescription)
                let offlineMovieList = self.readMovieList()
                callback(offlineMovieList, 1)
            }
        }
    }
    
    private func saveMovieList(list: [Movie]) {
        list.forEach { [weak self] (movie: Movie) in
            self?.persistanceProvider.saveRecord { (entity: MovieObject) in
                entity.id = Int64(movie.id)
                entity.title = movie.title
                entity.overview = movie.overview
                entity.releaseDate = movie.releaseDate
                entity.originalImgUrl = movie.originalImgUrl
                entity.smallImgUrl = movie.smallImgUrl
            } completion: { (_) in
                debugPrint("Success")
            }
        }
    }
    
    
    private func readMovieList() -> [Movie] {
        let objectList: [MovieObject] =  self.persistanceProvider.fetchAllRecords()
        
        return objectList.map { Movie(object: $0) }
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
