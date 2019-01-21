//
//  UIExtensions.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 21/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setupDismissKeyboard (){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard)
            )
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
