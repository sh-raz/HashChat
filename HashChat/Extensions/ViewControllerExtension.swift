//
//  ViewControllerExtension.swift
//  HashChat
//
//  Created by shilani on 07/09/2024.
//

import UIKit

extension UIViewController {
    func showAlertVCOnTheMainThread(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = AlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .fullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
        
    }
}
