//
//  PopularMovieView.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 02.03.2021.
//

import UIKit

class PopularMovieView: UIView {
    private(set) var tableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        super.updateConstraints()
    }
    
    private func setup() {
        setupSelf()
        setupTableView()

        setNeedsUpdateConstraints()
    }
    
    private func setupSelf() {
        backgroundColor = UIColor.backgroundColor
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.backgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }
}

