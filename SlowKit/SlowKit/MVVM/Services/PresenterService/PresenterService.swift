import UIKit

public class PresenterService : NSObject, IPresenterService {

	private unowned let container: Container
	private let selector: IViewControllerTypeSelector = ViewControllerDefaultTypeSelector()
	private let transitions: NSMapTable<UIViewController, TransitioningDelegate> = NSMapTable(keyOptions: .weakMemory, valueOptions: .strongMemory)

	internal init(container: Container) {
		self.container = container
	}

	@discardableResult
	public func viewModel<T: ViewControllerViewModelBase>(_ viewModel: T.Type) -> PresenterServiceEntryBuilder<T> where T: ViewControllerViewModelBase, T: INeedArguments {
		return PresenterServiceEntryBuilder<T>(presenter: self)
	}

	public func dismiss(animated: Bool) {
		if let topViewController = self.topViewController() {
			topViewController.dismiss(animated: animated, completion: nil)
		}
	}

	internal func present<T>(entry: PresenterServiceEntry<T>, args: T.Arguments, animated: Bool) where T: ViewControllerViewModelBase, T: INeedArguments {
		guard let vcType = self.selector.vcType(for: T.self) else { return }

		let key = ContainerEntryKey(instanceType: vcType)
		guard let vc = self.container.resolve(key: key, args: ()) as? UIViewController else { return }
		let vm = self.container.resolve(T.self, args: args)

		if let vm = vm {
			entry.params.forEach { $0(vm) }
		}

		if var vcvm = vc as? IHaveViewModel, vcvm.viewModelObject == nil {
			vcvm.viewModelObject = vm
		}

		if let topViewController = self.topViewController() {
			let transition = TransitioningDelegate(transition: entry.transition)
			self.transitions.setObject(transition, forKey: vc)
			vc.transitioningDelegate = transition
			topViewController.present(vc, animated: animated) {
				if let vm = vm {
					entry.onDidPresent.forEach { $0(vm) }
				}
			}
		}
	}

	private func topViewController() -> UIViewController? {
		var result = UIApplication.shared.keyWindow?.rootViewController
		while result?.presentedViewController != nil {
			result = result?.presentedViewController
		}
		return result
	}
}
