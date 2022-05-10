//
//  UITableViewCell+Extensions.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 9/05/22.
//

import UIKit

extension UITableViewCell {

    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
