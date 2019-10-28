//
//  VideoListView.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 10/5/19.
//  Copyright © 2019 Dinh Thanh An. All rights reserved.
//

import SwiftUI
import URLImage

struct VideoList: View {
    @ObservedObject var viewModel: VideoListViewModel

    var body: some View {
        List {
            ForEach (viewModel.videos) { video in
                NavigationLink(destination: PlayVideoView(video: video)) {
                    VideoRow(video: video)
                }
            }
        }
    }
}

struct VideoRow: View {
    let video: Video

    var body: some View {
        VStack (alignment: .leading) {
            URLImage(video.imageURL) { proxy in
            proxy.image
                .resizable()                     // Make image resizable
                .aspectRatio(contentMode: .fit)  // Fit the frame
                .clipped()                       // Clip overlaping parts
            }
            .frame(width: nil, height: 300)
            Text(video.title).font(.headline)
            Text(video.description).font(.subheadline)
        }
        .padding(.top, 8)
    }
}
