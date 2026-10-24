import XCTest
import UIKit
@testable import MangoTools
import MangoToolsObjCTestSupport

// Only the test harness requires Swift concurrency-era actor annotations.
// The library itself has no concurrency dependency and retains its iOS 9 floor.
@available(iOS 15.0, *)
final class MangoToolsTests: XCTestCase {
    @MainActor
    func testFramePropertiesPreserveOtherComponents() {
        let view = UIView(frame: CGRect(x: 1, y: 2, width: 30, height: 40))
        view.width = 50
        view.height = 60
        XCTAssertEqual(view.origin, CGPoint(x: 1, y: 2))
        view.right = 100
        view.bottom = 200
        XCTAssertEqual(view.frame, CGRect(x: 50, y: 140, width: 50, height: 60))
        view.left = 5
        view.top = 6
        XCTAssertEqual(view.origin, CGPoint(x: 5, y: 6))
        view.centerX = 80
        view.centerY = 90
        XCTAssertEqual(view.center, CGPoint(x: 80, y: 90))
        view.origin = CGPoint(x: 11, y: 12)
        view.size = CGSize(width: 70, height: 80)
        XCTAssertEqual(view.frame, CGRect(x: 11, y: 12, width: 70, height: 80))
    }

    @MainActor
    func testParentViewControllerFollowsResponderChain() {
        let controller = UIViewController()
        let child = UIView()
        controller.view.addSubview(child)
        XCTAssertTrue(child.parentViewController === controller)
        XCTAssertNil(UIView().parentViewController)
    }

    @MainActor
    func testTableCellRegistrationAndTypedDequeue() {
        let table = UITableView(frame: .zero, style: .plain)
        table.registerClass(ExampleTableCell.self)
        let indexPath = IndexPath(row: 0, section: 0) as NSIndexPath
        let cell: ExampleTableCell = table.dequeueReusableCellForIndexPath(indexPath)
        XCTAssertEqual(cell.reuseIdentifier, ExampleTableCell.defaultReuseIdentifier)
        XCTAssertEqual(ExampleTableCell.defaultReuseIdentifier, "ExampleTableCell")
    }

    @MainActor
    func testCollectionCellRegistrationAndTypedDequeue() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 20, height: 20)
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100),
                                          collectionViewLayout: layout)
        let dataSource = ExampleCollectionDataSource()
        collection.dataSource = dataSource
        collection.registerClass(ExampleCollectionCell.self)
        collection.reloadData()
        collection.layoutIfNeeded()
        let cell = collection.cellForItem(at: IndexPath(item: 0, section: 0)) as? ExampleCollectionCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.reuseIdentifier, ExampleCollectionCell.defaultReuseIdentifier)
        XCTAssertEqual(ExampleCollectionCell.defaultReuseIdentifier, "ExampleCollectionCell")
    }

    func testObjectiveCStringUtilities() {
        XCTAssertTrue(MangoToolsStringUtilitiesWork())
    }

    func testObjectiveCDateUtilities() {
        XCTAssertTrue(MangoToolsDateUtilitiesWork())
    }

    @MainActor
    func testObjectiveCAttributedStringUtilities() {
        XCTAssertTrue(MangoToolsAttributedStringUtilitiesWork())
    }

    @MainActor
    func testObjectiveCViewUtilities() {
        XCTAssertTrue(MangoToolsViewUtilitiesWork())
    }

    func testObjectiveCScopeCleanup() {
        XCTAssertTrue(MangoToolsScopeUtilitiesWork())
    }
}

private final class ExampleTableCell: UITableViewCell {}
private final class ExampleCollectionCell: UICollectionViewCell {}

private final class ExampleCollectionDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ExampleCollectionCell = collectionView.dequeueReusableCellForIndexPath(indexPath as NSIndexPath)
        return cell
    }
}
