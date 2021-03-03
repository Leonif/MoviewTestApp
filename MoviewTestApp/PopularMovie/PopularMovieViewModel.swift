//
//  PopularMovieViewModel.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 02.03.2021.
//

import MovieModel

public typealias EventHandler<T> = ((T) -> Void)



protocol PopularMovieOutput: class {
    func movieChosen(movie: Movie)
}

class PopularMovieViewModel {
    
    var eventHandler: EventHandler<Event>?
    
    var movieList: [Movie] = []
    weak var output: PopularMovieOutput?
    
    private let movieService: MovieServiceInterface
    
    init(movieService: MovieServiceInterface) {
        self.movieService = movieService
        
        loadFilms()
    }
    
    private func loadFilms() {
        movieService.getPopularMovieList(page: 1) { [weak self] (movieList) in
            guard let self = self else { return }
            self.movieList = movieList
            self.eventHandler?(.dataFetched)
        }
    }
    
}

extension PopularMovieViewModel {
    enum Event {
        case dataFetched
    }
}
