//
//  MyVideosViewModel.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 4/19/20.
//  Copyright © 2020 Dinh Thanh An. All rights reserved.
//

import Foundation

final class MyVideosViewModel: ObservableObject {
    private let videoManager: VideosManager = VideosManagerImpl()
    @Published private(set) var videos: [Video] = []

    func fetchAllVideos() {
        videos = videoManager.getAllVideos()
    }
}
