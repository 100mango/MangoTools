import XCTest
import ConsumerSwift
import ConsumerObjC

@MainActor
final class ConsumerTests: XCTestCase {
    func testPublicSwiftProductWithoutTestableImport() {
        XCTAssertTrue(publicSwiftHelpersWork())
    }

    func testObjectiveCOnlyProductAndCategoryLinking() {
        XCTAssertTrue(publicObjectiveCCategoriesWork())
    }
}
