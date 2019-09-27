import Foundation

public protocol IViewControllerTypeSelector {
	func vcType(for vmType: Any.Type) -> Any.Type?
}
