//
//  TableBuilder.swift
//  TableBuilder
//
//  Created by Maksim on 3/30/18.
//  Copyright © 2018 Maksim. All rights reserved.
//

import UIKit

public final class TableBuilder: NSObject {
    public private(set) weak var tableView: UITableView!
    public private(set) var sections: [TableSection]
    
    public init(with tableView: UITableView, sections: [TableSection]) {
        self.tableView = tableView
        self.sections = sections
        
        super.init()
        
        setDataSourceDelegate()
        initCells()
    }
    
    public init(with tableView: UITableView, rows: [ConfigurableRow]) {
        self.tableView = tableView
        self.sections = [TableSection(rows: rows)]
        
        super.init()
        
        setDataSourceDelegate()
        initCells()
    }
    
    public init(with tableView: UITableView) {
        self.tableView = tableView
        self.sections = [TableSection(rows: [])]
        
        super.init()
        
        setDataSourceDelegate()
    }
    
    private func initCells() {
        sections
            .flatMap { $0.rows }
            .flatMap { ($0.nib, $0.cellClass, $0.reuseId) }
            .forEach { nib, cellClass, reuseId in
                print(cellClass)
                tableView.registerCells(cellClass, reuseId: reuseId)
        }
    }
    
    private func setDataSourceDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

//MARK: - TableBuilder Operations

public extension TableBuilder {
    public func reloadData() { tableView.reloadData() }
    
    public func numberOfSections() -> Int {
        return sections.count
    }
    
    public func numberOfRows(in section: Int) -> Int {
        return sections[section].numberOfRows()
    }
    
    @discardableResult
    public func append(section: TableSection) -> Self {
        sections.append(section)
        return self
    }

    @discardableResult
    public func add(sections: [TableSection]) -> Self {
        self.sections.append(contentsOf: sections)
        return self
    }
    
    @discardableResult
    public func insert(section: TableSection, at index: Int) -> Self {
        sections.insert(section, at: index)
        return self
    }
    
    @discardableResult
    public func replace(section: TableSection, at index: Int) -> Self {
        if index >= 0 && index < sections.count {
            sections += [section]
        }
        return self
    }
    
    public func remove(at index: Int) -> TableSection? {
        guard index >= 0 && index < numberOfSections() else { return nil }
        return sections.remove(at: index)
    }
    
    @discardableResult
    public func removeAll() -> Self {
        sections.removeAll()
        return self
    }
}

//MARK: - Register Cells from Nib or Class

private extension UITableView {
    func registerCells(_ cellClass: AnyClass, reuseId: String) {
        let bundle = Bundle(for: cellClass)
        let path = bundle.path(forResource: String(describing: cellClass), ofType: "nib")
        
        switch path {
        case .some:
            register(UINib(nibName: String(describing: cellClass),
                           bundle: bundle),
                     forCellReuseIdentifier: reuseId)
        case .none:
            register(cellClass, forCellReuseIdentifier: reuseId)
        }
    }
}

//MARK: - TableView DataSource

extension TableBuilder: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowBuilder = sections[indexPath.section][indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: rowBuilder.reuseId
        ) else { fatalError() }
        
        rowBuilder.configure(cell: cell)
        
        return cell
    }
}

//MARK: - TableView Delegate

extension TableBuilder: UITableViewDelegate {
    public func tableView(_ tableView: UITableView,
                          heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowBuilder = sections[indexPath.section][indexPath.row]
        return rowBuilder.height
    }
    
    public func tableView(_ tableView: UITableView,
                          viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].header?.view
    }
    
    public func tableView(_ tableView: UITableView,
                          heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].header?.height ?? 0
    }
    
    public func tableView(_ tableView: UITableView,
                          titleForHeaderInSection section: Int) -> String? {
        return sections[section].header?.title
    }
    
    public func tableView(_ tableView: UITableView,
                          viewForFooterInSection section: Int) -> UIView? {
        return sections[section].footer?.view
    }
    
    public func tableView(_ tableView: UITableView,
                          heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].footer?.height ?? 0
    }
    
    public func tableView(_ tableView: UITableView,
                          titleForFooterInSection section: Int) -> String? {
        return sections[section].footer?.title
    }
    
    public func tableView(_ tableView: UITableView,
                          canEditRowAt indexPath: IndexPath) -> Bool {
        let row = sections[indexPath.section][indexPath.row]
        return row.actions.filter {
            guard case Action.edit = $0 else { return false }
            return true
        }.count > 0
    }
    
    public func tableView(_ tableView: UITableView,
                          editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let row = sections[indexPath.section][indexPath.row]
        
        return row.actions.reduce([]) { result, action -> [(UITableViewRowAction, UIColor)]? in
            guard case let .edit(actions) = action,
                let res = result else { return nil }
            return res + actions
        }?.map { $0.backgroundColor = $1; return $0 }
    }
    
    public func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section][indexPath.row]
        row.actions.forEach {
            guard case Action.select(let action) = $0 else { return }
            action(indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView,
                          didDeselectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section][indexPath.row]
        row.actions.forEach {
            guard case Action.deselect(let action) = $0 else { return }
            action(indexPath)
        }
    }
}
