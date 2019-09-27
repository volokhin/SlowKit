import XCTest
import UIKit
@testable import SlowKit

private class AutoCreateService : IContainerAutoCreate {
	required init(resolver: IResolver) { }
}

internal class ContainerTests_AutoCreate: XCTestCase {

	private var container: IContainer!

	internal override func setUp() {
		super.setUp()
		self.container = Container()
	}

	internal func test_resolve_without_register() {
		let service = self.container.resolve(AutoCreateService.self)
		XCTAssertNotNil(service)
	}
}
