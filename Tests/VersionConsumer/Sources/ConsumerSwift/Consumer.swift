import UIKit
import MangoTools
import MangoToolsObjC

@MainActor
public func publicSwiftHelpersWork() -> Bool {
    let view = UIView(frame: CGRect(x: 1, y: 2, width: 3, height: 4))
    view.right = 10
    view.bottom = 20
    let table = UITableView(frame: .zero, style: .plain)
    table.registerClass(ConsumerCell.self)
    let cell: ConsumerCell = table.dequeueReusableCellForIndexPath(IndexPath(row: 0, section: 0) as NSIndexPath)
    return view.origin == CGPoint(x: 7, y: 16)
        && cell.reuseIdentifier == ConsumerCell.defaultReuseIdentifier
        && NSStringFromClass(MangoLog.self) == "MangoLog"
}

private final class ConsumerCell: UITableViewCell {}
