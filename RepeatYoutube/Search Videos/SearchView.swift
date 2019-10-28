//
//  SearchView.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 10/5/19.
//  Copyright © 2019 Dinh Thanh An. All rights reserved.
//

import SwiftUI
import Combine

struct SearchView : View {
    @State private var query: String = ""
    let searchVideosViewModel: VideoListViewModel

    var body: some View {
        TextField("Type something...", text: $query, onCommit: fetch).onAppear(perform: fetch)
    }

    private func fetch() {
        searchVideosViewModel.text = query
        searchVideosViewModel.search()
    }
}
