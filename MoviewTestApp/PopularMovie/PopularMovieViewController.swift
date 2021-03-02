//
//  PopularMovieViewController.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 02.03.2021.
//

import UIKit

class PopularMovieViewController: UIViewController {
    
    private let rootView = PopularMovieView()
    private let viewModel: PopularMovieViewModel
    
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
        rootView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func setupBinding() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        
        viewModel.eventHandler = { [unowned self] event in
            switch event {
            case .dataFetched: rootView.tableView.reloadData()
            }
        }
    }
}

extension PopularMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = viewModel.movieList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = movie.title
        
        return cell
        
    }
}