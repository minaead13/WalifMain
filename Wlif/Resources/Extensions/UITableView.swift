//
//  UITableView.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import UIKit

extension UITableView {
    func registerCell<Cell : UITableViewCell>(cell : Cell.Type){
        let nibName = String(describing: cell.self)
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
}
