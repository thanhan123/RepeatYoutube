//
//  VideoListViewModel.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 10/8/19.
//  Copyright © 2019 Dinh Thanh An. All rights reserved.
//

import Combine

final class VideoListViewModel: ObservableObject {
    typealias SearchVideos = (String) -> AnyPublisher<[Video], SearchVideosError>

    private let _searchWithQuery = PassthroughSubject<String, SearchVideosError>()
    private var cancellables: [AnyCancellable] = []

    @Published private(set) var videos: [Video] = []
    @Published private(set) var errorMessage: String? = nil
    @Published private(set) var isLoading = false
    var text: String = ""

    private let searchVideosService = SearchVideosService()
    private let videosManager: VideosManager = VideosManagerImpl()

    init<S: Scheduler>(mainScheduler: S) {

        let searchTrigger = _searchWithQuery
            .filter { !$0.isEmpty }
            .debounce(for: .milliseconds(300), scheduler: mainScheduler)

        searchTrigger
            .map { _ in true }
            .replaceError(with: false)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)


        let response = searchTrigger
            .flatMapLatest { [unowned self] query -> AnyPublisher<[Video], SearchVideosError> in
                self.searchVideosService.search(matching: query)
                    .eraseToAnyPublisher()
            }
            .receive(on: mainScheduler)
            .share()

        response
            .map { _ in false }
            .replaceError(with: false)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)

        response
            .map { $0 }
            .sink(receiveCompletion: { [weak self] error in
                switch error {
                case .failure(let error):
                    self?.errorMessage = error.message
                case .finished:
                    self?.errorMessage = nil
                }
            }, receiveValue: { [weak self] videos in
                self?.videos = videos
            })
            .store(in: &cancellables)
    }

    func search() {
        _searchWithQuery.send(text)
    }

    func save(video: Video) {
        videosManager.save(video: video)
    }

    func remove(video: Video) {
        videosManager.remove(videos: [video])
    }
}
