//
//  ViewController.swift
//  TableBuilder
//
//  Created by Maksim on 3/29/18.
//  Copyright © 2018 Maksim. All rights reserved.
//

import UIKit

struct User { let name, lastName: String }

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var items = Array<Int>(1 ... 10)
    var builder: TableBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableBuilder()
    }
    
    private func setupTableBuilder() {
        let tableHeader = { (color: UIColor) -> UIView in
            let view = UIView()
            view.backgroundColor = color
            return view
        }
        
        let editSection = TableSection(rows: TableRow<TestCell>(
            item: "Edit Cell",
            actions: [
                .edit([
                    (action: .init(
                        style: .default,
                        title: "Add",
                        handler: { action, indexPath in
                            action.backgroundColor = .blue
                            print("Add Action: \(action)")
                        }), backgroundColor: .blue),
                    (action: .init(
                        style: .default,
                        title: "Remove",
                        handler: { action, indexPath in
                            action.backgroundColor = .blue
                            print("Add Action: \(action)")
                    }), backgroundColor: .red)
                ])
        ]))
        
        builder = TableBuilder(
            with: tableView,
            sections: [
                editSection,
                .init(rows: items.flatMap { TableRow<CodeCell>(
                      item: $0,
                      actions: [.select(printCurrentIndex)
                    ])}, header: .init(view: tableHeader(.black), height: 50)
                ),
                .init(rows: items.flatMap { TableRow<CodeCell>(item: $0) },
                      header: .init(title: "Swift Amazing", height: 30)
                ),
                .init(rows: items.flatMap { TableRow<TestCell>(item: String($0)) },
                      header: .init(view: tableHeader(.blue), height: 80)
                ),
                .init(rows: items.flatMap { TableRow<CustomCell>(item: String($0)) },
                      header: .init(title: "Swift Amazing", height: 30),
                      footer: .init(title: "The End...", height: 30)
                )
            ]
        )
        
        func printCurrentIndex(indexPath: IndexPath) { print(indexPath) }
    }
    
}
