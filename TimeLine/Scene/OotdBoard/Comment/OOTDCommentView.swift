//
//  OOTDCommentView.swift
//  TimeLine
//
//  Created by 김지연 on 12/16/23.
//

import UIKit
import RxDataSources

final class OOTDCommentView: BaseView {
    
    lazy var tableView = {
        let view = BoardTableView()
        view.isScrollEnabled = false
        view.rowHeight = UITableView.automaticDimension
        view.register(BoardCommentCell.self, forCellReuseIdentifier: BoardCommentCell.identifier)
        view.separatorStyle = .none
        
        return view
        
    }()
    
    let commentWriteView = CommentWriteView()
    
    override func configure() {
        [tableView, commentWriteView].forEach {
            addSubview($0)
        }
    }
    
    var dataSource: UITableViewDiffableDataSource<Int, Comment>!
    
    override func setConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        commentWriteView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    
    
}
