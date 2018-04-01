# MagicTableBuilder

MagicTableBuilder is a library which helps to build complex table views in declarative functional way. It based on generics and helps to avoid mistakes in compile time and make code pretty clean and testable.

# Features

- [x] Generic cells with type-safety
- [x] Abillity to define table view builder in functional style
- [x] Daclarative definition for all table view components (cells, sections, headers, footers, etc)
- [x] Automatic cell registration
- [x] Should be used with cells created from xib or code
- [x] Actions in chain (select/deselect etc.)
- [x] Define cell with generic model or viewModel

# Getting Started
TableRow definition:

```swift
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
```

Custom cell's definition

```swift
import MagicTableBuilder

class TestCell: UITableViewCell, ConfigurableCell {
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with value: String) {
        titleLabel.text = value
    }
}

```

Let's create Table Rows

```swift
import MagicTableBuilder

let row1 = TableRow<TestCell>(item: "Test Cell description")
let row2 = TableRow<UserCell>(item: UserData(firstName: "Steve", lastName: "Jobs"))
let row3 = TableRow<IntCell>(item: 777)
```

Define section with our custom rows:

```swift
let section = TableSection(rows: row1, row1, row1)
```

Finally, let's build it and watch our table!:

```swift
let tableBuilder = TableBuilder(with: tableView, sections: [section])
```

Pretty clean and quickly! I like it :)
You should keep reference on TableBuilder's instance as a property in your class with UITableView component.

## More complex example

We want to describe our TableView with different kinds of sections that contains row actions, headers and footers. How to create it? Very simple:

```swift
var items = Array<Int>(1 ... 10) // Our DataSource

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
```

## Custom Operators

```swift
section += TableRow<CustomCell>(item: "Custom Cell")
builder += section
```

# Installation
## Manual
Clone the repo and drag files from Sources folder into your Xcode project.

# License
MagicTableBuilder is available under the MIT license. See LICENSE for details.
