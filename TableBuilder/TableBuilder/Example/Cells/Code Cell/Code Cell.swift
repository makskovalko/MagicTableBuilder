//
//  Code Cell.swift
//  TableBuilder
//
//  Created by Maksim on 3/30/18.
//  Copyright © 2018 Maksim. All rights reserved.
//

import UIKit

class CodeCell: UITableViewCell, ConfigurableCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func configure(with value: Int) {
        textLabel?.text = String(value)
    }
}
