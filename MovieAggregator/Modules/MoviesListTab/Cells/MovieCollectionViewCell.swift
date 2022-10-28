// MovieCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Movie Cell for movies list.
final class MovieCollectionViewCell: UICollectionViewCell {
    // MARK: - Private Constants.

    private enum Constants {
        static let notFavoritesMovieImageName = "star"
        static let favoritesMovieImageName = "star.fill"
        static let posterPlaceholderImageName = "poster"
    }

    // MARK: - Public properties.

    private var movies: [MovieList.Movie]? = []

    // MARK: - Private visual components.

    private var cornerRadiusBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor(named: Colors.navigationBarColorName)?.cgColor
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor(named: Colors.navigationBarColorName)?.cgColor
        label.font = UIFont.systemFont(ofSize: 10, weight: .black)
        label.textColor = UIColor(named: Colors.tintColorName)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.baselineAdjustment = .none
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var favoriteMovieButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Constants.notFavoritesMovieImageName), for: .normal)
        button.tintColor = UIColor(named: Colors.favoriteMovieColorName)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Private properties.

    private var currentPosterPath = ""

    // MARK: - Life cycle.

    override func layoutSubviews() {
        setupUI()
    }

    override func prepareForReuse() {
        movieImageView.image = UIImage(named: Constants.posterPlaceholderImageName)
    }

    // MARK: - Public methods.

    func configureMoviesCell(movie: MovieList.Movie) {
        currentPosterPath = movie.posterPath ?? ""
        movieTitleLabel.text = movie.title
        ImageLoading.shared.getPoster(imagePosterPath: currentPosterPath) { data in
            DispatchQueue.main.async {
                if movie.posterPath == self.currentPosterPath {
                    self.movieImageView.image = UIImage(data: data)
                }
            }
        }
    }
}

extension MovieCollectionViewCell {
    // MARK: - Private methods.

    private func setupUI() {
        contentView.addSubview(cornerRadiusBackgroundView)
        cornerRadiusBackgroundView.addSubview(movieImageView)
        cornerRadiusBackgroundView.addSubview(movieTitleLabel)
        movieImageView.addSubview(favoriteMovieButton)
        setupConstraintsForBackgroundView()
        setupConstraintsForMovieImageView()
        setupConstraintsForMovieTitleLabel()
        setupConstraintsForFavoriteMovieButton()
    }

    private func setupConstraintsForBackgroundView() {
        NSLayoutConstraint.activate(
            [
                cornerRadiusBackgroundView.topAnchor
                    .constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
                cornerRadiusBackgroundView.bottomAnchor
                    .constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
                cornerRadiusBackgroundView.leadingAnchor
                    .constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
                cornerRadiusBackgroundView.trailingAnchor
                    .constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            ]
        )
    }

    private func setupConstraintsForMovieImageView() {
        NSLayoutConstraint.activate(
            [
                movieImageView.topAnchor
                    .constraint(equalTo: cornerRadiusBackgroundView.topAnchor),
                movieImageView.bottomAnchor
                    .constraint(equalTo: movieTitleLabel.topAnchor),
                movieImageView.leadingAnchor
                    .constraint(equalTo: cornerRadiusBackgroundView.leadingAnchor),
                movieImageView.trailingAnchor
                    .constraint(equalTo: cornerRadiusBackgroundView.trailingAnchor),
            ]
        )
    }

    private func setupConstraintsForMovieTitleLabel() {
        NSLayoutConstraint.activate(
            [
                movieTitleLabel.heightAnchor
                    .constraint(equalToConstant: 30),
                movieTitleLabel.bottomAnchor
                    .constraint(equalTo: cornerRadiusBackgroundView.bottomAnchor),
                movieTitleLabel.leadingAnchor
                    .constraint(equalTo: cornerRadiusBackgroundView.leadingAnchor),
                movieTitleLabel.trailingAnchor
                    .constraint(equalTo: cornerRadiusBackgroundView.trailingAnchor),
            ]
        )
    }

    private func setupConstraintsForFavoriteMovieButton() {
        NSLayoutConstraint.activate(
            [
                favoriteMovieButton.topAnchor
                    .constraint(equalTo: cornerRadiusBackgroundView.topAnchor, constant: 5),
                favoriteMovieButton.leadingAnchor
                    .constraint(equalTo: cornerRadiusBackgroundView.leadingAnchor, constant: 145),
                favoriteMovieButton.trailingAnchor
                    .constraint(equalTo: cornerRadiusBackgroundView.trailingAnchor)
            ]
        )
    }
}
