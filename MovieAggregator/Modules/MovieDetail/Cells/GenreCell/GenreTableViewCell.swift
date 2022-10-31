// GenreTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Cell with genre.
final class GenreTableViewCell: UITableViewCell {
    // MARK: - Private Constants.

    private enum Constants {
        static let genreTitle = "Жанр: "
        static let spaceText = " "
        static let commaText = ","
    }

    // MARK: - Private visual components.

    private let containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: Colors.textColorName)
        label.font = UIFont(name: ConstantsFonts.titleFontName, size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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

    // MARK: - Public properties.

    func configureCell(genre: MovieDetail) {
        var genres = String()
        for genre in genre.genres {
            genres += "\(genre.name)\(Constants.commaText)\(Constants.spaceText)"
        }
        let subGenres = genres.dropLast(2)
        genreLabel.text = String("\(Constants.genreTitle)\(subGenres)")
    }

    // MARK: - Private properties.

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(genreLabel)
        setupConstraintsForContentView()
        setupConstraintsForGenreLabel()
    }

    private func setupConstraintsForContentView() {
        NSLayoutConstraint.activate(
            [
                contentView.heightAnchor
                    .constraint(equalTo: containerView.heightAnchor),
                contentView.widthAnchor
                    .constraint(equalTo: containerView.widthAnchor),
                containerView.heightAnchor
                    .constraint(equalTo: genreLabel.heightAnchor),
                containerView.widthAnchor
                    .constraint(equalTo: genreLabel.widthAnchor),
                containerView.centerYAnchor
                    .constraint(equalTo: centerYAnchor),
                containerView.centerXAnchor
                    .constraint(equalTo: centerXAnchor)
            ]
        )
    }

    private func setupConstraintsForGenreLabel() {
        NSLayoutConstraint.activate(
            [
                genreLabel.centerYAnchor
                    .constraint(equalTo: containerView.centerYAnchor),
                genreLabel.centerXAnchor
                    .constraint(equalTo: containerView.centerXAnchor),
                genreLabel.heightAnchor
                    .constraint(equalToConstant: 50)
            ]
        )
    }
}
