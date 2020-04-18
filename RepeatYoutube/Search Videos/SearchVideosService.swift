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

struct SearchVideosService {
    private let networkClient = CombineNetworkingClient()
    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
    }
}

extension SearchVideosService {
    private var apiKey: String {
        return "AIzaSyD5hYWAxRb5h3oJUE8FFLlM8JWXgR3eo0w"
    }

    private var baseURL: String {
        return "https://www.googleapis.com/youtube/v3"
    }

    func search(matching query: String) -> AnyPublisher<[Video], Never> {
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
            .catch{ error -> AnyPublisher<[Video], Never> in
                return AnyPublisher<[Video], Never>.empty()
            }
        .eraseToAnyPublisher()
    }

    func convertToDictionary(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
