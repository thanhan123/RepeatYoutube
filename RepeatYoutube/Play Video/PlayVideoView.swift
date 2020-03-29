//
//  PlayVideoView.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 10/5/19.
//  Copyright © 2019 Dinh Thanh An. All rights reserved.
//

import SwiftUI

struct PlayVideoView: View {
    let video: Video

    @State private var startTrimmingAt: String = ""
    @State private var endTrimmingAt: String = ""

    @State private var startTime: TimeInterval? = nil
    @State private var endTime: TimeInterval? = nil
    @State private var isPlayingVideo: Bool = true

    @ObservedObject private var keyboardGuardian = KeyboardGuardian(textFieldCount: 3)

    var body: some View {
        VStack (alignment: .leading) {
            PlayingVideoView(
                videoID: video.id,
                startTime: self.$startTime,
                endTime: self.$endTime,
                isPlaying: self.$isPlayingVideo
            )
            .onDisappear {
                self.isPlayingVideo = false
            }
            Text("\(video.title)")
            HStack {
                TextField("start", text: $startTrimmingAt, onEditingChanged: {
                    if $0 { self.keyboardGuardian.showField = 0 }
                }, onCommit: {
                    if let seconds = Double(self.startTrimmingAt) {
                        self.startTime = seconds
                    }
                })
                TextField("end", text: $endTrimmingAt, onEditingChanged: {
                    if $0 { self.keyboardGuardian.showField = 0 }
                }, onCommit: {
                    self.endTime = 120
                })
            }
            .padding(.leading, 8)
        }
        .frame(width: nil, height: 350, alignment: .leading)
        .background(GeometryGetter(rect: $keyboardGuardian.rects[0]))
        .offset(y: keyboardGuardian.slide)
        .animation(.easeOut(duration: 0.5))
        .onAppear {
            self.keyboardGuardian.addObserver()
        }
        .onDisappear {
            self.keyboardGuardian.removeObserver()
        }
    }
}

#if DEBUG
struct PlayVideoView_Previews : PreviewProvider {
    static var previews: some View {
        PlayVideoView(
            video: Video(
                id: "91VxctZKz8U",
                title: "aaaaa",
                description: "bbbbb",
                imageURL: URL(string: "91VxctZKz8U")!
        ))
    }
}
#endif
