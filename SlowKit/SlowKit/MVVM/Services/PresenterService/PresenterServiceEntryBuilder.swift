import UIKit

public class PresenterServiceEntryBuilder<TViewModel> where TViewModel: ViewControllerViewModelBase, TViewModel: INeedArguments {

	private let presenter: PresenterService
	private let entry: PresenterServiceEntry<TViewModel>

	internal init(presenter: PresenterService) {
		self.presenter = presenter
		self.entry = PresenterServiceEntry()
	}

	@discardableResult
	public func withParams(_ closure: @escaping (TViewModel) -> Void) -> Self {
		self.entry.params.append(closure)
		return self
	}

	@discardableResult
	public func withTransition(_ transition: UIViewControllerAnimatedTransitioning) -> Self {
		self.entry.transition = transition
		return self
	}

	@discardableResult
	public func onDidPresent(_ closure: @escaping (TViewModel) -> Void) -> Self {
		self.entry.onDidPresent.append(closure)
		return self
	}

	public func present(args: TViewModel.Arguments, animated: Bool) {
		self.presenter.present(entry: self.entry, args: args, animated: animated)
	}
}

public extension PresenterServiceEntryBuilder where TViewModel.Arguments == Void {
	func present(animated: Bool) {
		self.presenter.present(entry: self.entry, args: (), animated: animated)
	}
}
