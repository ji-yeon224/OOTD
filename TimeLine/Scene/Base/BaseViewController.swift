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
    
    func showToastMessage(message: String, position: ToastPosition) {
            
        var style = ToastStyle()
        style.messageFont = .systemFont(ofSize: 13)
        DispatchQueue.main.async {
            self.view.makeToast(message, duration: 1.0, position: position, style: style)
        }
    }
    func showAlertWithCancel(title: String, message: String, okHandler: (() -> Void)?, cancelHandler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            okHandler?()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            cancelHandler?()
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        
        present(alert, animated: true)
    }
    
    
}
