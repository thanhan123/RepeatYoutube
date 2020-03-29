//
//  VideoListView.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 10/5/19.
//  Copyright © 2019 Dinh Thanh An. All rights reserved.
//

import SwiftUI
import Combine
import URLImage

struct VideoList: View {
    @ObservedObject var viewModel: VideoListViewModel
    @State private var isShowingAlert = false

    var body: some View {
        LoadingView(isShowing: self.$isShowingAlert) {
            List {
                ForEach (self.viewModel.videos) { video in
                    NavigationLink(destination: PlayVideoView(video: video)) {
                        VideoRow(video: video)
                    }
                }
            }.onReceive(self.viewModel.$isLoading) { (isLoading) in
                self.isShowingAlert = isLoading
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
