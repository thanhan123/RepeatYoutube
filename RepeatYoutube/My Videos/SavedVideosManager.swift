//
//  SavedVideosManager.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 4/26/20.
//  Copyright © 2020 Dinh Thanh An. All rights reserved.
//

import Foundation
import Combine

class SavedVideosManager: ObservableObject {
    private let videosManager: VideosManager
    @Published var savedVideosId: Set<String>
    private var cancellables = Set<AnyCancellable>()

    init(videosManager: VideosManager = VideosManagerImpl()) {
        self.videosManager = videosManager

        savedVideosId = Set(self.videosManager.getAllVideos().map{ $0.id })
        videosManager
            .videosOnAdded()
            .flatMap{ videos -> AnyPublisher<[String], Never> in
                Just(videos.map{ $0.id }).eraseToAnyPublisher()
        }.sink { [weak self] videoIds in
            videoIds.forEach {
                self?.savedVideosId.insert($0)
            }
        }.store(in: &cancellables)

        videosManager
            .videosOnDeleted()
            .flatMap{ videos -> AnyPublisher<[String], Never> in
                Just(videos.map{ $0.id }).eraseToAnyPublisher()
        }.sink { [weak self] videoIds in
            videoIds.forEach {
                self?.savedVideosId.remove($0)
            }
        }.store(in: &cancellables)
    }

    func save(video: Video) {
        videosManager.save(video: video)
    }

    func remove(video: Video) {
        videosManager.remove(videos: [video])
    }
}
