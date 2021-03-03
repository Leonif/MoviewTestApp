//
//  MovieDetails.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 03.03.2021.
//

import UIKit
import MovieModel

final class MovieDetailsViewController: UIViewController {
    
    private let rootView = MovieDetailsView()
    private let viewModel: MovieDetailsViewModel
    
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: .none, bundle: .none)
        setup()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
    }
    
    private func setupBinding() {
        
        updateUI(for: viewModel.movie)
        
        viewModel.eventHandler = { [unowned self] event in
            switch event {
            case .dataUpdated: updateUI(for: viewModel.movie)
            }
        }
    }
    
    private func updateUI(for movie: Movie) {
        rootView.titleLabel.text = viewModel.movie.title
        rootView.overviewLabel.text = viewModel.movie.overview
        rootView.relaseLabel.text = viewModel.movie.releaseDate
        rootView.posteImageView.kf.setImage(with: URL(string: viewModel.movie.originalImgUrl))
    }
}
