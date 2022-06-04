//
//  PostsGraphTableViewCell.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/02.
//

import SwiftUI

struct PostsGraphTableViewCellPreview: PreviewProvider {

    struct Wrapper: UIViewRepresentable {
        typealias UIViewType = PostsGraphTableViewCell

        let inputs: [PostsGraphTableViewCell.Input]
        init(inputs: [PostsGraphTableViewCell.Input]) {
            self.inputs = inputs
        }
        func makeUIView(context: UIViewRepresentableContext<Wrapper>) -> PostsGraphTableViewCell {
            let view = PostsGraphTableViewCell()
            view.apply(inputs: inputs)
            return view
        }
        func updateUIView(_ uiView: PostsGraphTableViewCell, context: UIViewRepresentableContext<Wrapper>) {
            uiView.apply(inputs: inputs)
        }
    }

    static var previews: some View {
        Group {
            Wrapper(
                inputs: [
                    .setPostsData(postsData: PostsDataMock.createMock())
                ]
            )
            .previewLayout(.fixed(width: 350, height: 350))
            Wrapper(
                inputs: [
                    .setPostsData(postsData: PostsDataMock.createMock())
                ]
            )
            .previewLayout(.fixed(width: 350, height: 350))
        }
    }
}
