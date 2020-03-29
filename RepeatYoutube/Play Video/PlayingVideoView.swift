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
    @Binding var startTime: TimeInterval?
    @Binding var endTime: TimeInterval?
    @Binding var isPlaying: Bool

    private let youtubeClient = XCDYouTubeClient.default()
    private let viewModel = PlayingVideoViewModel()

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<PlayingVideoView>) {
        if self.isPlaying {
            uiViewController.player?.play()
        } else {
            uiViewController.player?.pause()
            uiViewController.player = nil
        }

        if let startTime = startTime {
            viewModel.startTime = CMTimeMakeWithSeconds(startTime, preferredTimescale: 1)
        }

        if let endTime = endTime {
            let time = CMTimeMakeWithSeconds(endTime, preferredTimescale: 1)
            viewModel.endTime = time
            viewModel.removeObservers()
            viewModel.boundaryTimeObservers.append(
                uiViewController.player?.addBoundaryTimeObserver(
                    forTimes: [NSValue(time: time)],
                    queue: DispatchQueue.main
                ) {
                    uiViewController.player?.seek(to: self.viewModel.startTime)
            })
        }
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<PlayingVideoView>) -> AVPlayerViewController {
        let avPlayerVC = AVPlayerViewController()
        viewModel.observersRemovingHandler = { (observers) in
            if let player = avPlayerVC.player {
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
            }
        }
        return avPlayerVC
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
