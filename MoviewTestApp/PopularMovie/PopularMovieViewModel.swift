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
    private var originalMovieList: [Movie] = []
    
    private(set) var isLoading: Bool = false
    
    
    var filter: String? { didSet { search(basedOn: filter) } }
    weak var output: PopularMovieOutput?
    
    private let movieService: MovieServiceInterface
    
    init(movieService: MovieServiceInterface) {
        self.movieService = movieService
        
        loadFilms()
    }
    
    private func loadFilms() {
        movieService.getPopularMovieList(page: 1) { [weak self] (movieList) in
            guard let self = self else { return }
            self.originalMovieList = movieList
            self.movieList = self.originalMovieList
            self.eventHandler?(.dataFetched)
        }
    }
    
    private func search(basedOn filter: String?) {
        guard !isLoading else { return }
        guard let filter = filter, !filter.isEmpty else {
            movieList = originalMovieList
            self.eventHandler?(.dataFetched)
            return
        }
        
        isLoading = true
        movieService.searchMovie(query: filter) { [weak self] (movieList) in
            guard let self = self else { return }
            self.movieList = movieList
            self.eventHandler?(.dataFetched)
            self.isLoading = false
        }
    }
}

extension PopularMovieViewModel {
    enum Event {
        case dataFetched
    }
}
