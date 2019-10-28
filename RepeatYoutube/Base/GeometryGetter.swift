//
//  GeometryGetter.swift
//  RepeatYoutube
//
//  Created by Dinh Thanh An on 2019/10/28.
//  Copyright © 2019 Dinh Thanh An. All rights reserved.
//

import SwiftUI

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                DispatchQueue.main.async {
                    self.rect = geometry.frame(in: .global)
                }

                return AnyView(Color.clear)
            }
        }
    }
}
