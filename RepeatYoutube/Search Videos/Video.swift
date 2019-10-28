//
//  Video.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 10/5/19.
//  Copyright © 2019 Dinh Thanh An. All rights reserved.
//

import Foundation

struct Video: Identifiable, Decodable {
    var id: String

    let title, description: String
    let imageURL: URL

    var videoURL: URL {
        return URL(string: "https://www.youtube.com/embed/\(id)")!
    }

    enum CodingKeys: String, CodingKey {
        case id
        case snippet

        enum IdKeys: String, CodingKey {
            case videoId
        }

        enum SnippetKeys: String, CodingKey {
            case title
            case description
            case thumbnails

            enum ThumbnailKeys: String, CodingKey {
                case `default`
                case medium
                case high

                struct YoutubeVideoThumbanil: Codable {
                    let url: URL
                }
            }
        }
    }
}

extension Video {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let idContainer = try container.nestedContainer(keyedBy: CodingKeys.IdKeys.self, forKey: .id)
        id = try idContainer.decode(String.self, forKey: .videoId)

        let snippetContainer = try container.nestedContainer(keyedBy: CodingKeys.SnippetKeys.self, forKey: .snippet)
        title = try snippetContainer.decode(String.self, forKey: .title)
        description = try snippetContainer.decode(String.self, forKey: .description)

        let thumbnailsContainer = try snippetContainer.nestedContainer(
            keyedBy: CodingKeys.SnippetKeys.ThumbnailKeys.self,
            forKey: .thumbnails
        )
        //        let defaultThumbnail = try thumbnailsContainer.decode(CodingKeys.thumbnailKeys.YoutubeVideoThumbanil.self, forKey: .default)
        //        let mediumThumbnail = try thumbnailsContainer.decode(CodingKeys.thumbnailKeys.YoutubeVideoThumbanil.self, forKey: .medium)
        let highThumbnail = try thumbnailsContainer.decode(CodingKeys.SnippetKeys.ThumbnailKeys.YoutubeVideoThumbanil.self, forKey: .high)

        imageURL = highThumbnail.url
    }

    struct YoutubeVideosContainer: Decodable {
        private let items: [FailableDecodable<Video>]
        var videos: [Video] {
            return items.compactMap { $0.base }
        }
    }
}

struct ErrorResponse: Decodable, Error {
    let message: String
}

struct FailableDecodable<Base : Decodable> : Decodable {

    let base: Base?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}
