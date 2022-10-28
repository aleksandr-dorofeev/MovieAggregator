// CastTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Cell with cast collection view.
final class CastTableViewCell: UITableViewCell, UICollectionViewDataSource {
    // MARK: - Private Constants.

    private enum Identifier {
        static let actorCellID = "ActorCollectionCell"
    }

    // MARK: - Public Properties

    var movieId = Int()

    // MARK: - Private properties.

    private var cast: [CastResult.Cast] = []

    // MARK: - Private visual components.

    private let containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var castCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            ActorCollectionViewCell.self,
            forCellWithReuseIdentifier: Identifier.actorCellID
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellWidthConstant: CGFloat = 180
        let cellHeightConstant: CGFloat = 150
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: cellWidthConstant, height: cellHeightConstant)
        return layout
    }

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

    func loadCast(urlMovieID: String) {
        NetworkService.shared.fetchCast(for: urlMovieID, completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [self] in
                switch result {
                case let .success(cast):
                    guard let secureFetchCast = cast?.cast else { return }
                    guard !secureFetchCast.isEmpty else {
                        self.castCollectionView.reloadData()
                        return
                    }
                    self.cast.append(contentsOf: secureFetchCast)
                    self.castCollectionView.reloadData()
                case let .failure(error):
                    self.showError(error: error)
                }
            }
        })
    }

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(castCollectionView)
        setupConstraintsForContentView()
        setupConstraintsForCollectionView()
    }

    private func showError(error: Error) {
        print(error.localizedDescription)
    }

    private func setupConstraintsForContentView() {
        NSLayoutConstraint.activate(
            [
                contentView.heightAnchor
                    .constraint(equalTo: containerView.heightAnchor),
                contentView.widthAnchor
                    .constraint(equalTo: containerView.widthAnchor),
                containerView.heightAnchor
                    .constraint(equalTo: castCollectionView.heightAnchor),
                containerView.widthAnchor
                    .constraint(equalTo: castCollectionView.widthAnchor),
                containerView.centerYAnchor
                    .constraint(equalTo: centerYAnchor),
                containerView.centerXAnchor
                    .constraint(equalTo: centerXAnchor)
            ]
        )
    }

    private func setupConstraintsForCollectionView() {
        NSLayoutConstraint.activate([
            castCollectionView.centerXAnchor
                .constraint(equalTo: containerView.centerXAnchor),
            castCollectionView.centerYAnchor
                .constraint(equalTo: containerView.centerYAnchor),
            castCollectionView.heightAnchor
                .constraint(equalToConstant: 400)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cast.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Identifier.actorCellID,
                for: indexPath
            ) as? ActorCollectionViewCell
        else { return UICollectionViewCell() }
        let cast = cast[indexPath.row]
        cell.configureCell(cast: cast)
        return cell
    }
}
