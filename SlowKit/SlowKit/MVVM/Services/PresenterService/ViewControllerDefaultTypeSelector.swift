import Foundation

public final class ViewControllerDefaultTypeSelector : IViewControllerTypeSelector {

	private var cache: [String: AnyClass] = [:]

	public func vcType(for vmType: Any.Type) -> Any.Type? {
		var result: AnyClass? = nil
		let vmTypeString = String(reflecting: vmType)
		result = self.cache[vmTypeString]
		if result == nil, let vcTypeString = self.convertToViewControllerTypeString(vmTypeString) {
			let vcType: AnyClass? = NSClassFromString(vcTypeString)
			if let vcType = vcType {
				self.cache[vmTypeString] = result
				return vcType
			}
		}
		return result
	}

	private func convertToViewControllerTypeString(_ vmType: String) -> String? {
		if vmType.hasSuffix("VM") {
			let result = String(vmType.dropLast(2))
			if result.hasSuffix("VC") {
				return result
			} else {
				return result + "VC"
			}
		} else {
			return nil
		}
	}

}
