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
        
        let persistanceProvider = PersistanceFactory.persistanceProvider
        
        let service = MovieService(provider: networkService, persistanceProvider: persistanceProvider)
        
        let viewModel = PopularMovieViewModel(movieService: service)
        let viewController = PopularMovieViewController(viewModel: viewModel)
        
        return (viewController, viewModel)
    }
}
