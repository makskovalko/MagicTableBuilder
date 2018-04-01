//
//  ConfigurableCell.swift
//  TableBuilder
//
//  Created by Maksim on 3/30/18.
//  Copyright © 2018 Maksim. All rights reserved.
//

import UIKit

public protocol ConfigurableCell {
    associatedtype Value
    
    static var reuseId: String { get }
    static var nib: UINib? { get }
    static var height: CGFloat { get }
    
    func configure(with value: Value)
}

public extension ConfigurableCell where Self: UITableViewCell {
    public static var reuseId: String {
        return NSStringFromClass(Self.self)
    }
    
    public static var nib: UINib? {
        return nil
    }
    
    public static var height: CGFloat {
        return 44
    }
}
