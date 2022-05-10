//
//  ProfileFollowEditButton.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/07.
//

import SwiftUI

struct ProfileFollowEditButtonPreview: PreviewProvider {

    struct Wrapper: UIViewRepresentable {
        typealias UIViewType = ProfileFollowEditButton

        func makeUIView(context: UIViewRepresentableContext<Wrapper>) -> ProfileFollowEditButton {
            let view = ProfileFollowEditButton(style: .myProfile)
            return view
        }
        func updateUIView(_ uiView: ProfileFollowEditButton, context: UIViewRepresentableContext<Wrapper>) {
        }
    }

    static var previews: some View {
        Group {
            Wrapper(
            )
            .previewLayout(.sizeThatFits)
            .previewDevice("iPhone 8")
            Wrapper(
            )
            .previewLayout(.sizeThatFits)
            .previewDevice("iPhone 8")
        }
    }
}
