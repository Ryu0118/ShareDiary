//
//  ProfileUserInfoViewPreview.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/07.
//

import SwiftUI

struct ProfileUserInfoViewPreview: PreviewProvider { // (1)

    struct Wrapper: UIViewRepresentable { // (2)
        typealias UIViewType = ProfileUserInfoView

        let inputs: [ProfileUserInfoView.Input]
        init(input: [ProfileUserInfoView.Input]) {
            self.inputs = input
        }
        func makeUIView(context: UIViewRepresentableContext<Wrapper>) -> ProfileUserInfoView {
            let view = ProfileUserInfoView() // (3)
            view.apply(inputs: inputs) // (4)
            return view
        }
        func updateUIView(_ uiView: ProfileUserInfoView, context: UIViewRepresentableContext<Wrapper>) {
        }
    }

    static var previews: some View { // (5)
        Group {
            Wrapper(
                input: [
                    .setName(name: "りゅうのすけ"),
                    .setImage(image: R.image.nouser()!),
                    .setUserName(userName: "ryunosuke"),
                    .setUserIntroduction(introduction: "大学二年生,電気電子工学科")
                ]
            )
            .previewLayout(.fixed(width: 300, height: 100))
            .previewDevice("iPhone 8")
            Wrapper(
                input: [
                    .setName(name: "りゅうのすけりゅうのすけりゅうのすけ"),
                    .setImage(image: R.image.nouser()!),
                    .setUserName(userName: "ryunosukeryunosukeryunosuke"),
                    .setUserIntroduction(introduction: "大学二年生,電気電子工学科大学二年生,電気電子工学科大学二年生,電気電子工学科大学二年生,電気電子工学科大学二年生,電気電子工学科大学二年生,電気電子工学科大学二年生,電気電子工学科")
                ]
            )
            .previewLayout(.fixed(width: 300, height: 160))
            .previewDevice("iPhone 8")
        }
    }
}
