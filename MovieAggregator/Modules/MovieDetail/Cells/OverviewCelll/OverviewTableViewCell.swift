// OverviewTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Cell with overview about movie.
final class OverviewTableViewCell: UITableViewCell {
    // MARK: - Private visual components.

    private let containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let overviewMovieTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor(named: Colors.tintColorName)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.sizeToFit()
        textView.font = UIFont(name: ConstantsFonts.textFontName, size: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    // MARK: - Life cycle.

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("")
    }

    func configureCell(movie: MovieDetail) {
        overviewMovieTextView.text = movie.overview
    }

    // MARK: - Private methods.

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(overviewMovieTextView)
        setupConstraintsForContentView()
        setupConstraintsForOverviewTextView()
    }

    private func setupConstraintsForContentView() {
        NSLayoutConstraint.activate(
            [
                contentView.heightAnchor
                    .constraint(equalTo: containerView.heightAnchor),
                contentView.widthAnchor
                    .constraint(equalTo: containerView.widthAnchor),
                containerView.heightAnchor
                    .constraint(equalTo: overviewMovieTextView.heightAnchor),
                containerView.widthAnchor
                    .constraint(equalTo: overviewMovieTextView.widthAnchor),
                containerView.centerYAnchor
                    .constraint(equalTo: centerYAnchor),
                containerView.centerXAnchor
                    .constraint(equalTo: centerXAnchor)
            ]
        )
    }

    private func setupConstraintsForOverviewTextView() {
        NSLayoutConstraint.activate(
            [
                overviewMovieTextView.topAnchor
                    .constraint(equalTo: containerView.topAnchor, constant: 5),
                overviewMovieTextView.leadingAnchor
                    .constraint(equalTo: containerView.leadingAnchor, constant: 5),
                overviewMovieTextView.trailingAnchor
                    .constraint(equalTo: containerView.trailingAnchor, constant: 5)
            ]
        )
    }
}
