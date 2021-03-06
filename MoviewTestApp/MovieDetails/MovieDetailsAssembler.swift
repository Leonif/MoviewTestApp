//
//  MovieDetailsAssembler.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 03.03.2021.
//

import MovieModel
import UIKit

class  MovieDetailsAssembler {
    static func makeModule(movie: Movie) -> (viewController: MovieDetailsViewController, viewModel: MovieDetailsViewModel) {
        
        let networkService = NetworkProvider<MovieTraget>()
        
        let persistanceProvider = PersistanceFactory.persistanceProvider
        
        let viewModel = MovieDetailsViewModel(movie: movie, movieService: MovieService(provider: networkService, persistanceProvider: persistanceProvider))
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        
        return (viewController, viewModel)
    }
}

class PersistanceFactory {
    static var persistanceProvider: PersistenceProvider {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        return appdelegate.persistanceProvider
    }
}
