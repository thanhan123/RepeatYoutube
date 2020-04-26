//
//  SearchVideosService.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 10/6/19.
//  Copyright © 2019 Dinh Thanh An. All rights reserved.
//

import Foundation
import Combine
import NetworkClient
import Keys

enum SearchVideosError: Error {
    case limitExceeded(message: String)
    case otherError
}

extension SearchVideosError {
    var message: String {
        switch self {
        case .limitExceeded(let message):
            return message
        default:
            return "unknown error"
        }
    }
}

struct SearchVideosService {
    private let networkClient = CombineNetworkingClient()
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
    }
}

extension SearchVideosService {
    private var apiKey: String {
        return RepeatYoutubeKeys().youtubeAPIKey
    }

    private var baseURL: String {
        return "https://www.googleapis.com/youtube/v3"
    }

    func search(matching query: String) -> AnyPublisher<[Video], SearchVideosError> {
        guard let url = URL(string: "\(baseURL)/search") else {
            return .empty()
        }

        return networkClient.performRequest(
            url: url,
            parameters: ["q": query,
                         "key": apiKey,
                         "part": "snippet"],
            requestType: .get
        )
            .decode(type: Video.YoutubeVideosContainer.self, decoder: decoder)
            .map{ $0.videos }
            .mapError{ error -> SearchVideosError in
                switch error {
                case let networkError as NetworkError:
                    switch networkError {
                    case .otherError(let object):
                        if let data = object as? Data,
                            let errorDict = self.convertToDictionary(data: data),
                            let errorMessage = errorDict["message"] as? String {
                            return .limitExceeded(message: errorMessage)
                        }
                    default:
                        break
                    }
                    fallthrough
                default:
                    return .otherError
                }
        }
        .eraseToAnyPublisher()
    }

    private func convertToDictionary(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
