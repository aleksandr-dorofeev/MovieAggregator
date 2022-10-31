// Cast.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// CastResult model.
struct CastResult: Decodable {
    let id: Int
    let cast: [Cast]
}

/// Extension for cast.
extension CastResult {
    struct Cast: Decodable {
        let name: String
        let character: String?
        let profilePath: String?

        enum CodingKeys: String, CodingKey {
            case name
            case character
            case profilePath = "profile_path"
        }
    }
}
