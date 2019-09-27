import XCTest
import UIKit
import SlowKit

private class TestServiceWithArguments : INeedArguments {
	typealias Arguments = Int
	var argument: Int
	required init(argument: Int) {
		self.argument = argument
	}
}

internal class ContainerTests_Factory: XCTestCase {

	private var container: IContainer!

	internal override func setUp() {
		super.setUp()
		self.container = Container()
	}

	internal func test_resolve_facrory() {
		let factory = self.container.resolve(Factory<TestServiceWithArguments>.self)
		XCTAssertNotNil(factory)
	}

	internal func test_factory_creates_instance() {
		self.container.register(TestServiceWithArguments.self).withInit(TestServiceWithArguments.init)
		let factory = self.container.resolve(Factory<TestServiceWithArguments>.self)!
		let service = factory.make(42)
		XCTAssertNotNil(service)
		XCTAssertEqual(service?.argument, 42)
	}

	internal func test_factory_creates_per_request() {
		self.container.register(TestServiceWithArguments.self).withInit(TestServiceWithArguments.init)
		let factory = self.container.resolve(Factory<TestServiceWithArguments>.self)!
		let service1 = factory.make(1)
		let service2 = factory.make(2)
		XCTAssertNotNil(service1)
		XCTAssertNotNil(service2)
		XCTAssert(service1 !== service2)
	}
}
