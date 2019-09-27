import XCTest
import SlowKit

private protocol IService { }
private class Service : IService { }

internal class ContainerExamples: XCTestCase {

	internal override func setUp() {
		super.setUp()
	}

	// MARK: DI

	internal func test_register_per_request() {
		let container = Container()
		container.register(IService.self)
			.withInit(Service.init)
		let service = container.resolve(IService.self)
		XCTAssert(service != nil)
	}

	internal func test_register_single_instance() {
		let container = Container()
		container.register(IService.self)
			.withInit(Service.init)
			.singleInstance()
		let service = container.resolve(IService.self)
		XCTAssert(service != nil)
	}

}
