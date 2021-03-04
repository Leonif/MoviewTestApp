//
//  PopularMovieViewModel.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 02.03.2021.
//

import MovieModel

protocol PopularMovieOutput: class {
    func movieChosen(movie: Movie)
}

class PopularMovieViewModel {
    
    var eventHandler: EventHandler<Event>?
    
    private var lastOriginalPageNumber = 1
    private var lastFoundPageNumber = 1
    private var totalOriginalPages: Int?
    private var totalFoundPages: Int?
    
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
        movieService.getPopularMovieList(page: lastOriginalPageNumber) { [weak self] (movieList, totalPages) in
            guard let self = self else { return }
            self.totalOriginalPages = totalPages
            self.originalMovieList = movieList
            self.movieList = self.originalMovieList
            self.eventHandler?(.dataFetched)
        }
    }
    
    func loadNextPage() {
        guard !isPageLoading else { return }
        guard let totalOriginalPages = totalOriginalPages, lastOriginalPageNumber < totalOriginalPages else { return }
        
        isPageLoading = true
        lastOriginalPageNumber += 1
        
        movieService.getPopularMovieList(page: lastOriginalPageNumber) { [weak self] (movieList, _) in
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
            eventHandler?(.dataFetched)
            return
        }
        
        isLoading = true
        lastFoundPageNumber = 1
        movieService.searchMovie(query: filter, page: lastFoundPageNumber) { [weak self] (movieList, totalPages) in
            guard let self = self else { return }
            self.totalFoundPages = totalPages
            self.movieList = movieList
            self.eventHandler?(.dataFetched)
            self.isLoading = false
        }
    }
    
    func loadNextFoundPage() {
        guard !isPageLoading else { return }
        guard let filter = filter, !filter.isEmpty else { return }
        
        guard let totalFoundPages = totalFoundPages, lastFoundPageNumber < totalFoundPages else { return }

        isPageLoading = true
        lastFoundPageNumber += 1
        movieService.searchMovie(query: filter, page: lastFoundPageNumber) { [weak self] (movieList, _) in
            guard let self = self else { return }
            let lastCount = self.movieList.count
            self.movieList.append(contentsOf: movieList)
            self.eventHandler?(.nextPageFetched(lastCount: lastCount, batchCount: movieList.count))
            self.isPageLoading = false
        }
    }
}

extension PopularMovieViewModel {
    enum Event {
        case dataFetched
        case nextPageFetched(lastCount: Int, batchCount: Int)
    }
}
