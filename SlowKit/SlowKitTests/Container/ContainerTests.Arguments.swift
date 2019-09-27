import XCTest
import UIKit
@testable import SlowKit

private class TestServiceWithArguments : INeedArguments {
	typealias Arguments = Int
	var argument: Int
	required init(argument: Int) {
		self.argument = argument
	}
}

private class TestServiceWithArguments1: INeedArguments {
	typealias Arguments = String
	var argument: String
	required init(service: ITestService, argument: String) {
		self.argument = argument
	}
}

private class TestServiceWithArguments2: INeedArguments {
	typealias Arguments = String
	var argument: String
	required init(argument: String, service: ITestService) {
		self.argument = argument
	}
}

internal class ContainerTests_Arguments: XCTestCase {

	private var container: IContainer!

	internal override func setUp() {
		super.setUp()
		self.container = Container()
	}

	internal func test_resolve_with_arguments_returns_registered_instance_with_init() {
		self.container
			.register(TestServiceWithArguments.self)
			.withInit(TestServiceWithArguments.init)
		let service = self.container.resolve(TestServiceWithArguments.self, args: 1)
		XCTAssertNotNil(service)
	}

	internal func test_resolve_with_arguments_returns_registered_instance_with_factory() {
		self.container
			.register(TestServiceWithArguments.self)
			.withFactory { TestServiceWithArguments(argument: $1 as! Int) }
		let service = self.container.resolve(TestServiceWithArguments.self, args: 2)
		XCTAssertNotNil(service)
	}

	internal func test_resolve_pass_arguments_with_init() {
		self.container
			.register(TestServiceWithArguments.self)
			.withInit(TestServiceWithArguments.init)
		let service = self.container.resolve(TestServiceWithArguments.self, args: 1)!
		XCTAssertEqual(service.argument, 1)
	}

	internal func test_resolve_pass_arguments_with_factory() {
		self.container
			.register(TestServiceWithArguments.self)
			.withFactory { TestServiceWithArguments(argument: $1 as! Int) }
		let service = self.container.resolve(TestServiceWithArguments.self, args: 2)!
		XCTAssertEqual(service.argument, 2)
	}

	internal func test_resolve_with_arguments_in_any_order_1() {
		self.container.register(ITestService.self).withInit(TestService.init)
		self.container
			.register(TestServiceWithArguments1.self)
			.withInit(TestServiceWithArguments1.init)
		let service = self.container.resolve(TestServiceWithArguments1.self, args: "test1")
		XCTAssertNotNil(service)
		XCTAssertEqual(service?.argument, "test1")
	}

	internal func test_resolve_with_arguments_in_any_order_2() {
		self.container.register(ITestService.self).withInit(TestService.init)
		self.container
			.register(TestServiceWithArguments2.self)
			.withInit(TestServiceWithArguments2.init)
		let service = self.container.resolve(TestServiceWithArguments2.self, args: "test2")
		XCTAssertNotNil(service)
		XCTAssertEqual(service?.argument, "test2")
	}

}
