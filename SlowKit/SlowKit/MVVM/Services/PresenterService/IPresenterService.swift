import Foundation

public protocol IPresenterService {

	@discardableResult
	func viewModel<T>(_ viewModel: T.Type) -> PresenterServiceEntryBuilder<T> where T: ViewControllerViewModelBase, T: INeedArguments

	func dismiss(animated: Bool)
}
