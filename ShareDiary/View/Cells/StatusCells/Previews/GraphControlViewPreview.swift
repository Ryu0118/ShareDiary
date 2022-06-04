//
//  GraphControlView.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/02.
//

import SwiftUI

struct GraphControlViewPreview: PreviewProvider {

    struct Wrapper: UIViewRepresentable {
        typealias UIViewType = GraphControlView

        let inputs: [GraphControlView.Input]
        init(inputs: [GraphControlView.Input]) {
            self.inputs = inputs
        }
        func makeUIView(context: UIViewRepresentableContext<Wrapper>) -> GraphControlView {
            let view = GraphControlView()
            view.apply(inputs: inputs)
            return view
        }
        func updateUIView(_ uiView: GraphControlView, context: UIViewRepresentableContext<Wrapper>) {
            uiView.apply(inputs: inputs)
        }
    }

    static var previews: some View {
        Group {
            Wrapper(
                inputs: [
                    .setAllowedYears(years: ["2021", "2020", "2019", "2018"])
                ]
            )
            .previewLayout(.fixed(width: 350, height: 120))
            Wrapper(
                inputs: [
                    .setAllowedYears(years: ["2021"])
                ]
            )
            .previewLayout(.fixed(width: 350, height: 120))
        }
    }
}
