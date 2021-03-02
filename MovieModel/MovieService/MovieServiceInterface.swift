//
//  MovieServiceInterface.swift
//  MovieModel
//
//  Created by Nifantiev Leonid Dev on 03.03.2021.
//

import Foundation

public protocol MovieServiceInterface {
    func getPopularFilms(page: Int, callback: @escaping ([Movie]) -> Void)
}
