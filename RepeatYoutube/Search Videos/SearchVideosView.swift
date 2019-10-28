//
//  SearchVideosView.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 10/5/19.
//  Copyright © 2019 Dinh Thanh An. All rights reserved.
//

import SwiftUI
import Combine

struct SearchVideosView: View {
    let searchVideosViewModel = VideoListViewModel(mainScheduler: DispatchQueue.main)

    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                SearchView(searchVideosViewModel: searchVideosViewModel)
                    .frame(width: nil, height: 40)
                VideoList(viewModel: searchVideosViewModel)
            }.navigationBarTitle("Search Videos")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchVideosView()
    }
}
