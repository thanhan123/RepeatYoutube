//
//  VideoListViewModel.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 10/8/19.
//  Copyright © 2019 Dinh Thanh An. All rights reserved.
//

import Combine

final class VideoListViewModel: ObservableObject {
    typealias SearchVideos = (String) -> AnyPublisher<[Video], Never>

    private let _searchWithQuery = PassthroughSubject<String, Never>()
    private var cancellables: [AnyCancellable] = []

    @Published private(set) var videos: [Video] = []
    @Published private(set) var errorMessage: String? = nil
    @Published private(set) var isLoading = false
    var text: String = ""

    private let searchVideosService = SearchVideosService()

    init<S: Scheduler>(mainScheduler: S) {

        let searchTrigger = _searchWithQuery
            .filter { !$0.isEmpty }
            .debounce(for: .milliseconds(300), scheduler: mainScheduler)

        searchTrigger
            .map { _ in true }
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)


        let response = searchTrigger
            .flatMapLatest { [unowned self] query -> AnyPublisher<[Video], Never> in
                self.searchVideosService.search(matching: query)
                    .eraseToAnyPublisher()
            }
            .receive(on: mainScheduler)
            .share()

        response
            .map { _ in false }
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)

        response
            .map { $0 }
            .assign(to: \.videos, on: self)
            .store(in: &cancellables)
    }

    func search() {
        _searchWithQuery.send(text)
    }
}
