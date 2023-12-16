//
//  MyPageContent.swift
//  TimeLine
//
//  Created by 김지연 on 12/14/23.
//

import UIKit
import RxDataSources

struct MyPageContent: Hashable {
    let img: UIImage?
    let title: String
    var textColor: UIColor = Constants.Color.basicText
    let type: MyPageType
}



//let contents = [
//    MyPageSectionModel(name: "내 활동", items: myActivity),
//    MyPageSectionModel(name: "계정", items: account)
//]
//
//
//let myActivity = [
//    MyPageContent(img: Constants.Image.pencil, title: "내가 작성한 글", type: .mypost),
//    MyPageContent(img: Constants.Image.heart, title: "좋아요 한 게시글", type: .likeboard)
//]
//
//let account = [
//    MyPageContent(img: nil, title: "로그아웃", textColor: .systemBlue, type: .logout),
//    MyPageContent(img: nil, title: "탈퇴", textColor: .systemRed, type: .withdraw)
//]

let list = [
    MyPageContent(img: Constants.Image.pencil, title: "내가 작성한 글", type: .mypost),
    MyPageContent(img: Constants.Image.heart, title: "좋아요 한 게시글", type: .likeboard),
    MyPageContent(img: nil, title: "로그아웃", textColor: .systemBlue, type: .logout),
    MyPageContent(img: nil, title: "탈퇴", textColor: .systemRed, type: .withdraw)
]
