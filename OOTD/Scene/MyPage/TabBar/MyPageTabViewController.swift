//
//  TabBarViewController.swift
//  OOTD
//
//  Created by 김지연 on 12/23/23.
//

import UIKit
import Tabman
import Pageboy

final class MyPageTabViewController: TabmanViewController {
    
    var viewControllers: Array<UIViewController> = []
    private var id: String?
    let vc1 =  OOTDCollectViewController()
    init(id: String) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
        settingTabBar(ctBar: bar)
        addBar(bar, dataSource: self, at: .top)
    }
    
    private func config() {
        
        
        let vc2 = BoardViewController()
        vc2.boardType = .user(id: id ?? UserDefaultsHelper.userID)
        viewControllers.append(vc1)
        viewControllers.append(vc2)
    }
    
    private func settingTabBar (ctBar : TMBar.ButtonBar) {
       ctBar.layout.transitionStyle = .snap
       // 왼쪽 여백주기
       ctBar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 13.0, bottom: 0.0, right: 20.0)
       
       // 간격
       ctBar.layout.interButtonSpacing = 35
           
       ctBar.backgroundView.style = .blur(style: .light)
       
       // 선택 / 안선택 색 + font size
       ctBar.buttons.customize { (button) in
           button.tintColor = Constants.Color.subText
           button.selectedTintColor = .black
           button.font = UIFont.systemFont(ofSize: 16)
           button.selectedFont = UIFont.systemFont(ofSize: 16, weight: .medium)
       }
       
       // 인디케이터 (영상에서 주황색 아래 바 부분)
       ctBar.indicator.weight = .custom(value: 2)
        ctBar.indicator.tintColor = Constants.Color.mainColor
   }
    
}


extension MyPageTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
   
   func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
  
       // MARK: -Tab 안 글씨들
       switch index {
       case 0:
           return TMBarItem(title: "OOTD")
       case 1:
           return TMBarItem(title: "Board")
       default:
           let title = "Page \(index)"
           return TMBarItem(title: title)
       }

   }
   
   func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
       //위에서 선언한 vc array의 count를 반환합니다.
       return viewControllers.count
   }

   func viewController(for pageboyViewController: PageboyViewController,
                       at index: PageboyViewController.PageIndex) -> UIViewController? {
       return viewControllers[index]
   }

   func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
       return nil
   }
}
