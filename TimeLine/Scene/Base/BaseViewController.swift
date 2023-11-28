//
//  BaseViewController.swift
//  TimeLine
//
//  Created by 김지연 on 11/13/23.
//

import UIKit
import Toast

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() { view.backgroundColor = Constants.Color.background }
    
    func showOKAlert(title: String, message: String, handler: (() -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            handler?()
        }
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    func showCenterToast(message: String) {
            
        var style = ToastStyle()
        style.messageFont = .systemFont(ofSize: 13)
        DispatchQueue.main.async {
            self.view.makeToast(message, duration: 2.0, position: .center, style: style)
        }
    }
    
}
