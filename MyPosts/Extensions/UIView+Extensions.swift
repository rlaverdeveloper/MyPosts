//
//  UIView+Extensions.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 8/05/22.
//

import UIKit

extension UIView {

    func fadeIn(_ duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: duration, delay: .zero, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(_ duration: TimeInterval = 0.3, completion: ((Bool) -> (Void))? = nil) {

        UIView.animate(withDuration: duration, delay: .zero, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
