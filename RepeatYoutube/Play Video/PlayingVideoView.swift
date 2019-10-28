//
//  PlayingVideoView.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 2019/10/28.
//  Copyright © 2019 Dinh Thanh An. All rights reserved.
//

import AVKit
import XCDYouTubeKit
import SwiftUI

struct PlayingVideoView: UIViewControllerRepresentable {
    let videoID: String

    private let avPlayerVC = AVPlayerViewController()
    private let youtubeClient = XCDYouTubeClient.default()

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<PlayingVideoView>) {

    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<PlayingVideoView>) -> AVPlayerViewController {
        defer {
            youtubeClient.getVideoWithIdentifier(videoID) { [weak avPlayerVC] (youtubeVideo, error) in
                let streamURLs = youtubeVideo?.streamURLs
                guard let videoURL = streamURLs?[XCDYouTubeVideoQualityHTTPLiveStreaming]
                    ?? streamURLs?[XCDYouTubeVideoQuality.HD720.rawValue]
                    ?? streamURLs?[XCDYouTubeVideoQuality.medium360.rawValue]
                    ?? streamURLs?[XCDYouTubeVideoQuality.small240.rawValue] else {
                        return
                }

                avPlayerVC?.player = AVPlayer(url: videoURL)
                self.playVideo()
            }
        }
        return avPlayerVC
    }

    func pauseVideo() {
        avPlayerVC.player?.pause()
    }

    func playVideo() {
        avPlayerVC.player?.play()
    }

    func seek(to startTime: TimeInterval) {
        avPlayerVC.player?.seek(to: Date(timeIntervalSinceNow: startTime))
    }

    func set(endTime: TimeInterval) {
        print("***> set end time")
    }
}
