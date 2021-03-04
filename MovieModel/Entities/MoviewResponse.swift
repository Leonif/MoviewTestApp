//
//  MoviewResponse.swift
//  MovieModel
//
//  Created by Nifantiev Leonid Dev on 04.03.2021.
//

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
