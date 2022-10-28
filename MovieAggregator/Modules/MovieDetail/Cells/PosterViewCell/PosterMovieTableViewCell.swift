// PosterMovieTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Cell with poster image
final class PosterMovieTableViewCell: UITableViewCell {
    // MARK: - Private Constants.

    private enum Constants {
        static let bottomShadowImageName = "bottomShadow"
    }

    // MARK: - Private visual components.

    private let containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let detailMovieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    private let bottomShadowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.bottomShadowImageName)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Life cycle.

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods.

    func configurePosterImage(movie: MovieDetail) {
        guard let posterImage = movie.posterPath else { return }
        ImageLoading.shared.getPoster(imagePosterPath: posterImage, completion: { data in
            DispatchQueue.main.async {
                self.detailMovieImageView.image = UIImage(data: data)
            }
        })
    }

    // MARK: - Private methods.

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(detailMovieImageView)
        detailMovieImageView.addSubview(bottomShadowImageView)
        setupConstraintsForContentView()
        setupConstraintsForDetailImageView()
        setupConstraintsForBottomShadowImageView()
    }

    private func setupConstraintsForContentView() {
        NSLayoutConstraint.activate(
            [
                contentView.heightAnchor
                    .constraint(equalTo: containerView.heightAnchor),
                contentView.widthAnchor
                    .constraint(equalTo: containerView.widthAnchor),
                containerView.heightAnchor
                    .constraint(equalTo: detailMovieImageView.heightAnchor),
                containerView.widthAnchor
                    .constraint(equalTo: detailMovieImageView.widthAnchor),
                containerView.centerYAnchor
                    .constraint(equalTo: centerYAnchor),
                containerView.centerXAnchor
                    .constraint(equalTo: centerXAnchor)
            ]
        )
    }

    private func setupConstraintsForDetailImageView() {
        NSLayoutConstraint.activate(
            [
                detailMovieImageView.centerYAnchor
                    .constraint(equalTo: containerView.centerYAnchor),
                detailMovieImageView.centerXAnchor
                    .constraint(equalTo: containerView.centerXAnchor),
                detailMovieImageView.heightAnchor
                    .constraint(equalToConstant: 600)
            ]
        )
    }

    private func setupConstraintsForBottomShadowImageView() {
        NSLayoutConstraint.activate(
            [
                bottomShadowImageView.bottomAnchor
                    .constraint(equalTo: detailMovieImageView.bottomAnchor),
                bottomShadowImageView.heightAnchor
                    .constraint(equalToConstant: 150),
                bottomShadowImageView.leadingAnchor
                    .constraint(equalTo: detailMovieImageView.leadingAnchor),
                bottomShadowImageView.trailingAnchor
                    .constraint(equalTo: detailMovieImageView.trailingAnchor)
            ]
        )
    }
}
