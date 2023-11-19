//
//  TabBarController.swift
//  TimeLine
//
//  Created by 김지연 on 11/19/23.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = Constants.Color.background
        tabBar.tintColor = Constants.Color.mainColor
        tabBar.unselectedItemTintColor = Constants.Color.basicText
        setTabBar()
        
    }
    
    private func setTabBar() {
        
        let boardVC = BoardViewController()
        boardVC.tabBarItem.image = Constants.Image.board
        boardVC.tabBarItem.title = "Board"
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem.image = Constants.Image.myPage
        homeVC.tabBarItem.title = "MY"
        
        viewControllers = [boardVC, homeVC]
        
    }
    
}
