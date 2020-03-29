//
//  SearchVideosService.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 10/6/19.
//  Copyright © 2019 Dinh Thanh An. All rights reserved.
//

import Foundation
import Combine

struct SearchVideosService {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
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
        guard var components = URLComponents(string: "\(baseURL)/search") else {
            return .empty()
        }
        components.queryItems = [URLQueryItem(name: "q", value: query),
                                 URLQueryItem(name: "key", value: apiKey),
                                 URLQueryItem(name: "part", value: "snippet")]

        guard
            let url = components.url
            else { preconditionFailure("Can't create url for query: \(query)") }

        let request = URLRequest(url: url)
        return session
            .dataTaskPublisher(for: request)
            .map({ data, _ in
                return data
            })
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
