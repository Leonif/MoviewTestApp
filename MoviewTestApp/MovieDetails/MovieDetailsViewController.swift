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
    private let imageLoader = ImageLoader()
    
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .none)
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
    
    private func setupBinding() {
        updateUI(for: viewModel.movie)
        
        viewModel.eventHandler = { [unowned self] event in
            switch event {
            case .dataUpdated: updateUI(for: viewModel.movie)
            }
        }
    }
    
    private func updateUI(for movie: Movie) {
        rootView.titleLabel.text = movie.title
        rootView.overviewLabel.text = movie.overview
        rootView.relaseLabel.text = movie.releaseDate
        
        if let url = URL(string: movie.originalImgUrl ?? "") {
            rootView.posterImageView.image = getPlaceholder(for: movie)
            
            imageLoader.load(url: url) { [weak self] image in
                self?.rootView.posterImageView.image = image
            }
        }
    }
    
    private func getPlaceholder(for movie: Movie) -> UIImage? {
        if let urlString = movie.originalImgUrl, let url1 = URL(string: urlString),
           let placeholder = imageLoader.readCahedImage(url: url1) {
            
            return placeholder
        
        } else if let urlString = movie.smallImgUrl, let url2 = URL(string: urlString),
             let placeholder = imageLoader.readCahedImage(url: url2) {
        
            return placeholder
        }
        
        return .none
    }
}
