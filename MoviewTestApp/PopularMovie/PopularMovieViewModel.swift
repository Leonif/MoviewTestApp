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
    private var lastPageNumber = 10
    
    var movieList: [Movie] = []
    private var originalMovieList: [Movie] = []
    
    private(set) var isLoading: Bool = false
    private(set) var isPageLoading: Bool = false
    
    var filter: String? { didSet { search(basedOn: filter) } }
    weak var output: PopularMovieOutput?
    
    private let movieService: MovieServiceInterface
    
    init(movieService: MovieServiceInterface) {
        self.movieService = movieService
        
        loadMovies()
    }
    
    private func loadMovies() {
        movieService.getPopularMovieList(page: lastPageNumber) { [weak self] (movieList) in
            guard let self = self else { return }
            self.originalMovieList = movieList
            self.movieList = self.originalMovieList
            self.eventHandler?(.dataFetched)
        }
    }
    
    func loadNextPage() {
        guard !isPageLoading else { return }
        
        isPageLoading = true
        lastPageNumber += 1
        
        movieService.getPopularMovieList(page: lastPageNumber) { [weak self] (movieList) in
            guard let self = self else { return }
            
            let lastCount = self.originalMovieList.count
            
            self.originalMovieList.append(contentsOf: movieList)
            self.movieList.append(contentsOf: movieList)
            
            self.eventHandler?(.nextPageFetched(lastCount: lastCount, batchCount: movieList.count))
            self.isPageLoading = false
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
        case nextPageFetched(lastCount: Int, batchCount: Int)
    }
}
