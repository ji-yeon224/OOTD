//
//  IndicatorView.swift
//  TimeLine
//
//  Created by 김지연 on 12/16/23.
//

import UIKit
import NVActivityIndicatorView

final class IndicatorView: BaseView {
    
    let backView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        view.backgroundColor = Constants.Color.lightGrayColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    let indicatorView = NVActivityIndicatorView(frame: .zero, type: .ballPulseSync, color: Constants.Color.mainColor, padding: 0)

    
    override func configure() {
        self.backgroundColor = .clear
        addSubview(backView)
        backView.addSubview(indicatorView)
    }
    
    override func setConstraints() {
        
        backView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
            
        }
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(backView)
            make.size.equalTo(30)
        }
        
    }
    
    func start() {
        indicatorView.startAnimating()
    }
    func end() {
        indicatorView.stopAnimating()
    }
    
    
}
