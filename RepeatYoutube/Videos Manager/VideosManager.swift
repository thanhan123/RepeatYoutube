//
//  VideosManager.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 4/19/20.
//  Copyright © 2020 Dinh Thanh An. All rights reserved.
//

import CoreData

protocol VideosManager {
    func save(video: Video)
    func getAllVideos() -> [Video]
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
}
