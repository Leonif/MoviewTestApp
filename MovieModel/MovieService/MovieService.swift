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
    public let title: String
    public let originalImgUrl: String
    public let smallImgUrl: String
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        let addr = try container.decode(String.self, forKey: .posterImgUrl)
        originalImgUrl = "https://image.tmdb.org/t/p/original\(addr)"
        smallImgUrl = "https://image.tmdb.org/t/p/w200\(addr)"
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case posterImgUrl = "poster_path"
    }
}

public class MovieService: MovieServiceInterface {
    private let provider: NetworkProvider<MovieTraget>
    
    public init(provider: NetworkProvider<MovieTraget>) {
        self.provider = provider
    }
    
    public func getPopularFilms(page: Int, callback: @escaping ([Movie]) -> Void) {
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
