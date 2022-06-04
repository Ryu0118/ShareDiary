//
//  PostsGraphView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/31.
//

import SwiftUI

struct PostsGraphViewPreview: PreviewProvider {

    struct Wrapper: UIViewRepresentable {
        typealias UIViewType = PostsGraphView

        let inputs: [PostsGraphView.Input]
        init(inputs: [PostsGraphView.Input]) {
            self.inputs = inputs
        }
        func makeUIView(context: UIViewRepresentableContext<Wrapper>) -> PostsGraphView {
            let view = PostsGraphView()
            view.apply(inputs: inputs)
            return view
        }
        func updateUIView(_ uiView: PostsGraphView, context: UIViewRepresentableContext<Wrapper>) {
            uiView.apply(inputs: inputs)
        }
    }

    static var previews: some View {
        Group {
            Wrapper(
                inputs: [
                    .setPostsData(postsData: PostsDataMock.createMock()[0])
                ]
            )
            .previewLayout(.fixed(width: 350, height: 150))
            Wrapper(
                inputs: [
                    .setPostsData(postsData: PostsDataMock.createMock()[1])
                ]
            )
            .previewLayout(.fixed(width: 350, height: 150))
            Wrapper(
                inputs: [
                    .setPostsData(postsData: PostsDataMock.createMock()[2])
                ]
            )
            .previewLayout(.fixed(width: 350, height: 150))
        }
    }
}
