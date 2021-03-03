//
//  MovieDetailsAssembler.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 03.03.2021.
//

import MovieModel

class  MovieDetailsAssembler {
    static func makeModule(movie: Movie) -> (viewController: MovieDetailsViewController, viewModel: MovieDetailsViewModel) {
        
        let networkService = NetworkProvider<MovieTraget>()
        
        let viewModel = MovieDetailsViewModel(movie: movie, movieService: MovieService(provider: networkService))
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        
        return (viewController, viewModel)
    }
}
