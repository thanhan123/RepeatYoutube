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

    init(videoID: String) {
        self.videoID = videoID
    }

    private let avPlayerVC = AVPlayerViewController()
    private let youtubeClient = XCDYouTubeClient.default()
    private let viewModel = PlayingVideoViewModel()

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<PlayingVideoView>) {

    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<PlayingVideoView>) -> AVPlayerViewController {
        viewModel.observersRemovingHandler = { (observers) in
            if let player = self.avPlayerVC.player {
                observers.forEach(player.removeTimeObserver)
            }
        }
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
                if let endTime = self.viewModel.endTime {
                    self.setEndTimeObserver(time: endTime)
                }
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

    func set(startTime: TimeInterval) {
        self.viewModel.startTime = CMTimeMakeWithSeconds(startTime, preferredTimescale: 1)
    }

    func set(endTime: TimeInterval) {
        let time = CMTimeMakeWithSeconds(endTime, preferredTimescale: 1)
        self.viewModel.endTime = time
        self.viewModel.removeObservers()
        setEndTimeObserver(time: time)
    }

    private func setEndTimeObserver(time: CMTime) {
        viewModel.boundaryTimeObservers.append(
            avPlayerVC.player?.addBoundaryTimeObserver(
                forTimes: [NSValue(time: time)],
                queue: DispatchQueue.main
            ) {
                self.avPlayerVC.player?.seek(to: self.viewModel.startTime)
        })
    }
}

final class PlayingVideoViewModel {
    var startTime: CMTime = .zero
    var endTime: CMTime?
    var boundaryTimeObservers = [Any?]()
    var observersRemovingHandler: (([Any?]) -> Void)?

    func removeObservers() {
        observersRemovingHandler?(boundaryTimeObservers)
    }

    deinit {
        removeObservers()
    }
}
