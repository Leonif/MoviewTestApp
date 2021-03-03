//
//  MovieDetailsViewModel.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 03.03.2021.
//

import MovieModel

class MovieDetailsViewModel {

    private(set) var movie: Movie
    private let movieService: MovieServiceInterface
    
    var eventHandler: EventHandler<Event>?
    
    init(movie: Movie, movieService: MovieServiceInterface) {
        self.movie = movie
        self.movieService = movieService
        
        loadMovie()
    }
    
    private func loadMovie() {
        movieService.getMovieDetails(id: movie.id, callback: { [weak self] movie in
            guard let self = self else { return }
            self.movie = movie
            self.eventHandler?(.dataUpdated)
            
        })
    }
}

extension MovieDetailsViewModel {
    enum Event {
        case dataUpdated
    }
}
