//
//  OOTDCellProtocol.swift
//  TimeLine
//
//  Created by 김지연 on 12/16/23.
//

import Foundation

protocol OOTDCellProtocol: AnyObject {
    func deletePost(id: String, idx: Int)
    func editPost(item: Post)
    func showComment(comments: [Comment], id: String)
    func likeButtonTap(id: String)
}
