// ImageLoading.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Loading image.
final class ImageLoading {
    // MARK: - Private enums.

    private enum UrlComponent {
        static let posterPathImageUrl = "https://image.tmdb.org/t/p/w500"
    }

    // MARK: - Singleton.

    static let shared = ImageLoading()

    // MARK: - Private properties.

    private let session = URLSession.shared
    private var posterImagesMap: [String: Data] = [:]
    private var actorImagesMap: [String: Data] = [:]

    // MARK: - Life cycle.

    private init() {}

    // MARK: - Public methods.

    func getPoster(imagePosterPath: String, completion: @escaping (Data) -> ()) {
        let imagePath = "\(UrlComponent.posterPathImageUrl)\(imagePosterPath)"
        if let data = posterImagesMap[imagePath] {
            completion(data)
        } else {
            loadPoster(imagePosterPath: imagePath, completion: completion)
        }
    }

    func getActorImage(imageActorPath: String, completion: @escaping (Data) -> ()) {
        let imagePath = "\(UrlComponent.posterPathImageUrl)\(imageActorPath)"
        if let data = actorImagesMap[imagePath] {
            completion(data)
        } else {
            loadActorImage(imageActorPath: imagePath, completion: completion)
        }
    }

    // MARK: - Private methods

    private func loadPoster(imagePosterPath: String, completion: @escaping (Data) -> Void) {
        guard
            let urlComponents = URLComponents(
                string: "\(UrlComponent.posterPathImageUrl)\(imagePosterPath)"
            ),
            let url = urlComponents.url
        else {
            return
        }
        session.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            self.posterImagesMap[imagePosterPath] = data
            completion(data)
        }.resume()
    }

    private func loadActorImage(imageActorPath: String, completion: @escaping (Data) -> Void) {
        guard
            let urlComponents = URLComponents(
                string: "\(UrlComponent.posterPathImageUrl)\(imageActorPath)"
            ),
            let url = urlComponents.url
        else {
            return
        }
        session.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            self.actorImagesMap[imageActorPath] = data
            completion(data)
        }.resume()
    }
}
