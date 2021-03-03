//
//  MovieService.swift
//  MovieModel
//
//  Created by Nifantiev Leonid Dev on 02.03.2021.
//

import Moya

struct MoviewResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


public struct Movie: Decodable {
    public let id: Int
    public let title: String
    public let overview: String
    public let releaseDate: String
    public let originalImgUrl: String
    public let smallImgUrl: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        let addr = try container.decode(String.self, forKey: .posterImgUrl)
        originalImgUrl = "https://image.tmdb.org/t/p/original\(addr)"
        smallImgUrl = "https://image.tmdb.org/t/p/w200\(addr)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case posterImgUrl = "poster_path"
        case overview
        case releaseDate = "release_date"
    }
}

public class MovieService: MovieServiceInterface {
    private let provider: NetworkProvider<MovieTraget>
    
    public init(provider: NetworkProvider<MovieTraget>) {
        self.provider = provider
    }
    
    public func getPopularMovieList(page: Int, callback: @escaping ([Movie]) -> Void) {
        let target = MovieTraget.popular(page: 1)
        provider.request(target: target) { (result) in
            switch result {
            case let .success(response):
                let movieResponse: MoviewResponse? = response.data.unbox()
                callback(movieResponse?.results ?? [])
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
