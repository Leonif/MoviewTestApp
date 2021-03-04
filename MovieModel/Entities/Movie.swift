//
//  Movie.swift
//  MovieModel
//
//  Created by Nifantiev Leonid Dev on 04.03.2021.
//

public struct Movie: Decodable {
    public let id: Int
    public let title: String
    public let overview: String
    public let releaseDate: String
    public let originalImgUrl: String?
    public let smallImgUrl: String?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        if let addr = try container.decodeIfPresent(String.self, forKey: .posterImgUrl) {
            originalImgUrl = "https://image.tmdb.org/t/p/original\(addr)"
            smallImgUrl = "https://image.tmdb.org/t/p/w200\(addr)"
        } else {
            originalImgUrl = nil
            smallImgUrl = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case posterImgUrl = "poster_path"
        case overview
        case releaseDate = "release_date"
    }
}
