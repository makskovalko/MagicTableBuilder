//
//  TableRow.swift
//  TableBuilder
//
//  Created by Maksim on 3/30/18.
//  Copyright © 2018 Maksim. All rights reserved.
//

import UIKit

public struct TableRow<CellType: UITableViewCell>: ConfigurableRow where CellType: ConfigurableCell {
    public var reuseId: String { return CellType.reuseId }
    public var nib: UINib? { return CellType.nib }
    public var height: CGFloat { return CellType.height }
    public var cellClass: AnyClass { return CellType.self }
    
    public var item: CellType.Value
    public private(set) var actions: [Action]
    
    public init(item: CellType.Value, actions: [Action] = []) {
        self.item = item
        self.actions = actions
    }
    
    public func configure(cell: UITableViewCell) {
        (cell as? CellType)?.configure(with: item)
    }
}
