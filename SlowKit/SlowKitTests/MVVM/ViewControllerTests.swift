import Foundation
import XCTest
import SlowKit

internal class ViewControllerTests: XCTestCase {

	internal func test_no_retain_circle_if_sets_vm() {

		var vc: TestViewController? = TestViewController()
		var vm: TestViewModel? = TestViewModel()
		let weakVc: Weak<TestViewController> = Weak(vc!)
		let weakVm: Weak<TestViewModel> = Weak(vm!)

		vc = nil
		vm = nil

		XCTAssert(weakVc.isAlive == false)
		XCTAssert(weakVm.isAlive == false)
	}
}
