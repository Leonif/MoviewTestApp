//
//  PopularMovieViewController.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 02.03.2021.
//

import UIKit
import Kingfisher

final class PopularMovieViewController: UIViewController {
    
    private let rootView = PopularMovieView()
    private let viewModel: PopularMovieViewModel
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let movieCellId = "cell_id"
    
    init(viewModel: PopularMovieViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: .none, bundle: .none)
        setup()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        super.loadView()
        
        view = rootView
    }
    
    private func setup() {
        rootView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: movieCellId)
        
        setupSearchController()
    }
    
    private func setupBinding() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        
        viewModel.eventHandler = { [unowned self] event in
            switch event {
            case .dataFetched: rootView.tableView.reloadData()
            case let .nextPageFetched(lastCount, batch):
                insertNewPage(lastCount: lastCount, batch: batch)
            }
        }
    }
    
    
    private func insertNewPage(lastCount: Int, batch: Int) {
        var indexPath: [IndexPath] = []
        
        let newLastRow = lastCount + batch
        
        for row in lastCount..<newLastRow {
            indexPath.append(.init(row: row, section: 0))
        }
        
        rootView.tableView.insertRows(at: indexPath, with: .automatic)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension PopularMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = viewModel.movieList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: movieCellId)!
        cell.textLabel?.text = movie.title
        
        if let url = URL(string: movie.smallImgUrl ?? "") {
            cell.imageView?.kf.setImage(with: url) { [weak tableView] result in
                switch result {
                case .success:
                    if indexPath.row < tableView?.visibleCells.count ?? 0 {
                        tableView?.reloadRows(at: [indexPath], with: .none)
                    }
                default: break
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.movieList[indexPath.row]
        viewModel.output?.movieChosen(movie: movie)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == viewModel.movieList.count - 1 {
            if searchController.isActive {
                viewModel.loadNextFoundPage()
            } else {
                viewModel.loadNextPage()
            }
            
        }
    }
}


extension PopularMovieViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive else { return }
        
        viewModel.filter = searchController.searchBar.text
    }
}
