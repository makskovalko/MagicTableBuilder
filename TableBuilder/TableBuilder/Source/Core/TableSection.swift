//
//  TableSection.swift
//  TableBuilder
//
//  Created by Maksim on 3/30/18.
//  Copyright © 2018 Maksim. All rights reserved.
//

import UIKit

public extension TableSection {
    public struct SupplementaryView {
        public let view: UIView?
        public let height: CGFloat
        public let title: String?
        
        public init(view: UIView?, height: CGFloat, title: String?) {
            self.view = view
            self.height = height
            self.title = title
        }
        
        public init(view: UIView?, height: CGFloat) {
            self.view = view
            self.height = height
            self.title = nil
        }
        
        public init(title: String?, height: CGFloat) {
            self.view = nil
            self.height = height
            self.title = title
        }
    }
}

public final class TableSection {
    public private(set) var rows: [ConfigurableRow]
    
    public private(set) var header: SupplementaryView?
    public private(set) var footer: SupplementaryView?
    
    public subscript(index: Int) -> ConfigurableRow {
        return rows[index]
    }
    
    public init(rows: [ConfigurableRow]) { self.rows = rows }
    
    public init(rows: ConfigurableRow...) { self.rows = rows }
    
    public init(_ rows: [ConfigurableRow]...) { self.rows = rows.flatMap { $0 }}
}

public extension TableSection {
    public convenience init(rows: [ConfigurableRow],
                     header: SupplementaryView? = nil,
                     footer: SupplementaryView? = nil) {
        self.init(rows)
        self.header = header
        self.footer = footer
    }
    
    public convenience init(rows: ConfigurableRow...,
                     header: SupplementaryView? = nil,
                     footer: SupplementaryView? = nil) {
        self.init(rows)
        self.header = header
        self.footer = footer
    }
}

public extension TableSection {
    public func append(_ row: ConfigurableRow) {
        self.rows += [row]
    }
    
    public func row(at index: Int) -> ConfigurableRow? {
        guard index >= 0 && index < rows.count else { return nil }
        return rows[index]
    }
    
    @discardableResult
    public func remove(at index: Int) -> ConfigurableRow? {
        guard index >= 0 && index < rows.count else { return nil }
        return rows.remove(at: index)
    }
    
    public func removeAll() { rows = [] }
    
    public func numberOfRows() -> Int { return rows.count }
}
