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
    @State private var isShowingAlert = false

    var body: some View {
        NavigationView {
            LoadingView(isShowing: self.$isShowingAlert) {
                List {
                    ForEach (self.viewModel.videos) { video in
                        NavigationLink(destination: PlayVideoView(video: video)) {
                            VideoRow(video: video, saveVideoHandler: { video in

                            })
                        }
                    }
                }.onAppear {
                    self.viewModel.fetchAllVideos()
                }
            }.navigationBarTitle("My Videos")
        }
    }
}
