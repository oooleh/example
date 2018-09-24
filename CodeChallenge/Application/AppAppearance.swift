//
//  AppAppearance.swift
//  CodeChallenge
//
//  Created by Oleh on 23.09.18.
//

import Foundation
import  UIKit

class AppColors {
    
    static let lightGray = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
    static let lightRed = UIColor(red: 255/255.0, green: 131/255.0, blue: 131/255.0, alpha: 1.0)
}

final class AppAppearance {
    
    static func setupAppearance() {
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }
}

extension UINavigationController
{
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
