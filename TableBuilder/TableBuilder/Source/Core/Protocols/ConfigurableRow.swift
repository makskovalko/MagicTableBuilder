//
//  ConfigurableRow.swift
//  TableBuilder
//
//  Created by Maksim on 3/30/18.
//  Copyright © 2018 Maksim. All rights reserved.
//

import UIKit

public protocol ConfigurableRow {
    var reuseId: String { get }
    var nib: UINib? { get }
    var height: CGFloat { get }
    var cellClass: AnyClass { get }
    var actions: [Action] { get }
    
    func configure(cell: UITableViewCell)
}
