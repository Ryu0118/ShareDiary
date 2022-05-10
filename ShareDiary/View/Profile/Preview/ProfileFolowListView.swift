//
//  ProfileFollowListView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/07.
//

import SwiftUI

struct ProfileFollowListViewPreview: PreviewProvider {

    struct Wrapper: UIViewRepresentable {
        typealias UIViewType = ProfileFollowListView

        let inputs: [ProfileFollowListView.Input]
        init(inputs: [ProfileFollowListView.Input]) {
            self.inputs = inputs
        }
        func makeUIView(context: UIViewRepresentableContext<Wrapper>) -> ProfileFollowListView {
            let view = ProfileFollowListView()
            view.apply(inputs: inputs)
            return view
        }
        func updateUIView(_ uiView: ProfileFollowListView, context: UIViewRepresentableContext<Wrapper>) {
            uiView.apply(inputs: inputs)
        }
    }

    static var previews: some View {
        Group {
            Wrapper(
                inputs: [
                    .setFollowCount(200),
                    .setFollowerCount(300),
                    .setPostCount(100)
                ]
            )
            .previewLayout(.fixed(width: 350, height: 60))
            .previewDevice("iPhone 8")
            .padding()
            Wrapper(
                inputs: [
                    .setFollowCount(9900000),
                    .setFollowerCount(30890),
                    .setPostCount(18928372)
                ]
            )
            .previewLayout(.fixed(width: 350, height: 60))
            .previewDevice("iPhone 8")
            .padding()
        }
    }
}
