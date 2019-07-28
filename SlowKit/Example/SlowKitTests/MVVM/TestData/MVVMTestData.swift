import Foundation
import SlowKit

internal class TestViewModel : ViewControllerViewModelBase { }

internal class TestViewController : ViewControllerBase<TestViewModel> {
	internal var viewModelChangedInvocationsCount = 0
	internal override func viewModelChanged() {
		super.viewModelChanged()
		self.viewModelChangedInvocationsCount += 1
	}
}
