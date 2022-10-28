// MovieInfoTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Cell with movie info.
final class MovieInfoTableViewCell: UITableViewCell {
    // MARK: - Private Visual Components.

    private let containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: ConstantsFonts.titleFontName, size: 25)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: Colors.tintColorName)
        return label
    }()

    private let movieReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: Colors.textColorName)
        label.font = UIFont(name: ConstantsFonts.textFontName, size: 18)
        return label
    }()

    private let movieRatingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: Colors.textColorName)
        label.font = UIFont(name: ConstantsFonts.titleFontName, size: 15)
        return label
    }()

    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Private properties.

    var movie: MovieList.Movie?

    // MARK: - Life cycle.

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Public methods.

    func configureCell(movie: MovieDetail) {
        movieTitleLabel.text = movie.title
        movieReleaseDateLabel.text = movie.releaseDate
        guard let rating = movie.voteAverage else { return }
        movieRatingLabel.text = "\(rating)"
    }

    // MARK: - Private methods.

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(movieTitleLabel)
        infoStackView.addArrangedSubview(movieReleaseDateLabel)
        infoStackView.addArrangedSubview(movieRatingLabel)
        setUpConstraints()
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor
                .constraint(equalTo: containerView.heightAnchor),
            contentView.widthAnchor
                .constraint(equalTo: containerView.widthAnchor),
            containerView.heightAnchor
                .constraint(equalTo: infoStackView.heightAnchor),
            containerView.widthAnchor
                .constraint(equalTo: infoStackView.widthAnchor),
            containerView.centerYAnchor
                .constraint(equalTo: centerYAnchor),
            containerView.centerXAnchor
                .constraint(equalTo: centerXAnchor),

            infoStackView.centerYAnchor
                .constraint(equalTo: containerView.centerYAnchor),
            infoStackView.centerXAnchor
                .constraint(equalTo: containerView.centerXAnchor),
            infoStackView.heightAnchor
                .constraint(equalToConstant: 100)
        ])
    }
}
