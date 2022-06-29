// 
//  PostCell.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PostCell: UICollectionViewCell, InputAppliable {
    
    /*
     PostCircleDateView, impressionLabel, titleLabel
     PostImageCollectionViewController
     PostMessageView
     PostStatusView
     */

    enum Input {

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(input: Input) {
        
    }
 
}
