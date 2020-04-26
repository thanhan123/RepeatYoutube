//
//  MyVideosView.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 4/19/20.
//  Copyright © 2020 Dinh Thanh An. All rights reserved.
//

import SwiftUI

struct MyVideosView: View {
    @ObservedObject var viewModel: MyVideosViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach (self.viewModel.videos) { video in
                    NavigationLink(destination: PlayVideoView(video: video)) {
                        VideoRow(video: video)
                    }
                }
            }.onAppear {
                self.viewModel.fetchAllVideos()
            }.navigationBarTitle("My Videos")
        }
    }
}
