//
//  VideosManager.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 4/19/20.
//  Copyright © 2020 Dinh Thanh An. All rights reserved.
//

import CoreData
import Combine

protocol VideosManager {
    func save(video: Video)
    func remove(videos: [Video])
    func getAllVideos() -> [Video]
    func videosOnAdded() -> AnyPublisher<[Video], Never>
    func videosOnDeleted() -> AnyPublisher<[Video], Never>
}

struct VideosManagerImpl: VideosManager {
    private let coreDataContext = CoreDataManager.shared.persistentContainer.viewContext

    func save(video: Video) {
        guard let entity = NSEntityDescription.entity(forEntityName: "VideoEntity", in: coreDataContext) else {
            return
        }
        let videoEntity = VideoEntity(entity: entity, insertInto: coreDataContext)
        videoEntity.setup(with: video)
        try? coreDataContext.save()
    }

    func getAllVideos() -> [Video] {
        let fetchRequest = NSFetchRequest<VideoEntity>(entityName: "VideoEntity")
        let result = try? coreDataContext.fetch(fetchRequest)
        return result?.map(Video.init(videoEntity:)) ?? []
    }

    func remove(videos: [Video]) {
        for video in videos {
            let fetchRequest = NSFetchRequest<VideoEntity>(entityName: "VideoEntity")
            fetchRequest.predicate = NSPredicate(format: "id = %@", video.id)
            try? coreDataContext.fetch(fetchRequest).forEach(coreDataContext.delete(_:))
        }
    }

    func videosOnAdded() -> AnyPublisher<[Video], Never> {
        videosOnChanged(NSInsertedObjectsKey)
    }

    func videosOnDeleted() -> AnyPublisher<[Video], Never> {
        videosOnChanged(NSDeletedObjectsKey)
    }

    private func videosOnChanged(_ statusKey: String) -> AnyPublisher<[Video], Never> {
        NotificationCenter
            .default
            .publisher(for: .NSManagedObjectContextObjectsDidChange, object: coreDataContext)
            .map(\.userInfo)
            .compactMap{ $0?[statusKey] as? Set<NSManagedObject> }
            .filter{
                $0.count > 0
        }.map{
            $0.compactMap { object in
                if let videoEntity = object as? VideoEntity {
                    return Video(videoEntity: videoEntity)
                }
                return nil
            }
        }
        .eraseToAnyPublisher()
    }
}
