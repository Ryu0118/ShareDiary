//
//  TitlesTableViewCell.swift
//  ShareDiary
//
//  Created by Ryu on 2022/05/27.
//

import SwiftUI

struct TitlesTableViewCellPreview: PreviewProvider {

    struct Wrapper: UIViewRepresentable {
        typealias UIViewType = TitlesTableViewCell

        let inputs: [TitlesTableViewCell.Input]
        init(inputs: [TitlesTableViewCell.Input]) {
            self.inputs = inputs
        }
        func makeUIView(context: UIViewRepresentableContext<Wrapper>) -> TitlesTableViewCell {
            let view = TitlesTableViewCell(style: .default, reuseIdentifier: "TableViewCell")
            view.apply(inputs: inputs)
            return view
        }
        func updateUIView(_ uiView: TitlesTableViewCell, context: UIViewRepresentableContext<Wrapper>) {
            uiView.apply(inputs: inputs)
        }
    }

    static var previews: some View {
        Group {
            Wrapper(
                inputs: [
                    .setTitle(title: Title(titleName: "連続投稿", terms: [Title.Term(grade: .gold, termName: "一年", isAchieved: false), Title.Term(grade: .silver, termName: "一ヶ月", isAchieved: true), Title.Term(grade: .bronze, termName: "一週間", isAchieved: true)]))
                ]
            )
            .previewLayout(.fixed(width: 350, height: 85))

            Wrapper(
                inputs: [
                    .setTitle(title: Title(titleName: "投稿数", terms: [Title.Term(grade: .gold, termName: "500日", isAchieved: true), Title.Term(grade: .silver, termName: "100日", isAchieved: true), Title.Term(grade: .bronze, termName: "10日", isAchieved: true)]))
                ]
            )
            .previewLayout(.fixed(width: 350, height: 85))
        }
    }
}
