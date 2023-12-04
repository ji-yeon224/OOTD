//
//  BoardView.swift
//  TimeLine
//
//  Created by 김지연 on 11/19/23.
//

import UIKit
import Kingfisher
import RxDataSources

final class BoardView: BaseView {
    
    lazy var tableView = {
        let view = UITableView(frame: .zero)
        view.backgroundColor = Constants.Color.background
        view.register(BoardTableViewCell.self, forCellReuseIdentifier: BoardTableViewCell.identifier)
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
    
    lazy var writeButton = {
        let view = UIButton()
        view.setImage(Constants.Image.plus, for: .normal)
        view.backgroundColor = Constants.Color.mainColor
        view.tintColor = Constants.Color.background
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        return view
    }()
    
    let dataSource = RxTableViewSectionedReloadDataSource<PostListModel> { dataSource, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.identifier, for: indexPath) as? BoardTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.titleLabel.text = item.title
        cell.contentLabel.text = item.content
        
        cell.createrLabel.text = item.creator.nick
        if item.image.isEmpty {
            cell.thumbnailImage.isHidden = true
            
        } else {
//            let imgURL = BaseURL.baseURL+"/"+
            cell.thumbnailImage.setImage(with: item.image[0], resize: 70)
            
        }
        
        return cell
    }
    
    override func configure() {
        super.configure()
        
        addSubview(tableView)
        addSubview(writeButton)
        
        
    }
    
    override func setConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        writeButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
    
}
