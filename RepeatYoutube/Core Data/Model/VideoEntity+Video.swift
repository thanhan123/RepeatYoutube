//
//  VideoEntity+Video.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 4/19/20.
//  Copyright © 2020 Dinh Thanh An. All rights reserved.
//

import CoreData

extension VideoEntity {
    func setup(with video: Video) {
        self.id = video.id
        self.imageURL = video.imageURL
        self.title = video.title
        self.videoDescription = video.description
    }
}
