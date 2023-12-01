//
//  BoardCommentCell.swift
//  TimeLine
//
//  Created by 김지연 on 12/1/23.
//

import UIKit

final class BoardCommentCell: BaseCollectionViewCell {
    
    let label = PlainLabel(size: 13, color: Constants.Color.basicText, line: 1)
    
    override func configure() {
        contentView.addSubview(label)
    }
    
    override func setConstraints() {
        label.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView).inset(10)
            make.height.equalTo(40)
        }
    }
    
    
    
}

struct CommentModel: Hashable {
    let id = UUID()
    var comment: String
}


var dummyComment = [
    CommentModel(comment: "111"),
    CommentModel(comment: "222"),
    CommentModel(comment: "333")
]
