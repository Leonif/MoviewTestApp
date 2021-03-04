//
//  MovieDetailsView.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 03.03.2021.
//

import UIKit

class MovieDetailsView: ScrollableView {
    
    private(set) var titleLabel = UILabel()
    private(set) var overviewLabel = UILabel()
    private(set) var relaseLabel = UILabel()
    private(set) var posteImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            relaseLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            relaseLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            relaseLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            posteImageView.topAnchor.constraint(equalTo: relaseLabel.bottomAnchor, constant: 16),
            posteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posteImageView.heightAnchor.constraint(equalToConstant: 700),
            posteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        super.updateConstraints()
    }
    
    
    private func setup() {
        contentView.backgroundColor = UIColor.backgroundColor
        scrollView.backgroundColor = UIColor.backgroundColor
        
        setupTitleLabel()
        setupOverviewLabel()
        setupReleaseLabel()
        setupImageView()
        
        
        setNeedsUpdateConstraints()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 32)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.textColor
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }
    
    private func setupOverviewLabel() {
        overviewLabel.font = UIFont.systemFont(ofSize: 15)
        overviewLabel.numberOfLines = 0
        overviewLabel.textColor = UIColor.textColor
        overviewLabel.textAlignment = .center
        overviewLabel.lineBreakMode = .byWordWrapping
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(overviewLabel)
    }
    
    private func setupReleaseLabel() {
        relaseLabel.font = UIFont.systemFont(ofSize: 15)
        relaseLabel.numberOfLines = 0
        relaseLabel.textColor = UIColor.textColor
        relaseLabel.textAlignment = .center
        relaseLabel.lineBreakMode = .byWordWrapping
        relaseLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(relaseLabel)
    }
    
    private func setupImageView() {
        posteImageView.contentMode = .scaleAspectFill
        posteImageView.clipsToBounds = true
        posteImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(posteImageView)
    }
}

