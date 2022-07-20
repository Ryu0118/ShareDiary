//
//  LikeButton.swift
//  ShareDiary
//
//  Created by Ryu on 2022/07/20.
//

import SwiftUI

struct LikeButtonPreview: PreviewProvider {

    struct Wrapper: UIViewRepresentable {
        typealias UIViewType = LikeButton

        func makeUIView(context: UIViewRepresentableContext<Wrapper>) -> LikeButton {
            let view = LikeButton()
            return view
        }
        func updateUIView(_ uiView: LikeButton, context: UIViewRepresentableContext<Wrapper>) {
        }
    }

    static var previews: some View {
        Group {
            Wrapper(
            )
            .previewLayout(.fixed(width: 20, height: 20))
            Wrapper(
            )
            .previewLayout(.fixed(width: 30, height: 30))
        }
    }
}
