//
//  Actions.swift
//  TableBuilder
//
//  Created by Maksim on 3/30/18.
//  Copyright © 2018 Maksim. All rights reserved.
//

import UIKit

public enum Action {
    public typealias SelectAction = (IndexPath) -> Void
    public typealias EditAction = (action: UITableViewRowAction, backgroundColor: UIColor)
    
    case select(SelectAction)
    case deselect(SelectAction)
    case edit([EditAction])
}
