//
//  ScrollableView.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 03.03.2021.
//

import UIKit

class ScrollableView: UIView {
    private(set) lazy var scrollView = UIScrollView()
    private(set) lazy var contentView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame); setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder); setup()
    }

    override func updateConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        super.updateConstraints()
    }

    // MARK: - Private
    private func setup() {
        setupScrollView()
        setupContainerView()
    }

    private func setupContainerView() {
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }

    private func setupScrollView() {
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
    }
}
