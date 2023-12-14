//
//  MyPageContent.swift
//  TimeLine
//
//  Created by 김지연 on 12/14/23.
//

import UIKit

struct MyPageContent: Hashable {
    let img: UIImage?
    let title: String
    var textColor: UIColor = Constants.Color.basicText
}


let myActivity = [
    MyPageContent(img: Constants.Image.pencil, title: "내가 작성한 글"),
    MyPageContent(img: Constants.Image.heart, title: "좋아요 한 게시글")
]

let account = [
    MyPageContent(img: nil, title: "로그아웃", textColor: .systemBlue),
    MyPageContent(img: nil, title: "탈퇴", textColor: .systemRed)
]
