//
//  PopularMovieAssembler.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 02.03.2021.
//

import MovieModel



class  PopularMovieAssembler {
    static func makeModule() -> (viewController: PopularMovieViewController, viewModel: PopularMovieViewModel) {
        
        let networkService = NetworkProvider<MovieTraget>()
        
        let viewModel = PopularMovieViewModel(movieService: MovieService(provider: networkService))
        let viewController = PopularMovieViewController(viewModel: viewModel)
        
        return (viewController, viewModel)
    }
}
