//
//  Operators.swift
//  TableBuilder
//
//  Created by Maksim on 3/30/18.
//  Copyright © 2018 Maksim. All rights reserved.
//

public func += (section: TableSection, _ row: ConfigurableRow) {
    section.append(row)
}

public func += (builder: TableBuilder, section: TableSection) {
    builder.append(section: section)
}

public func += (builder: TableBuilder, rows: [ConfigurableRow]) {
    builder.append(section: TableSection(rows))
}

public func + (lhs: TableSection, rhs: TableSection) -> [TableSection] {
    return [lhs, rhs]
}

public func + (lhs: ConfigurableRow, rhs: ConfigurableRow) -> [ConfigurableRow] {
    return [lhs, rhs]
}
