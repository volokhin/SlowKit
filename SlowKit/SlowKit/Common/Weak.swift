import Foundation

public class Weak<T: AnyObject> {

	public private(set) weak var value: T?

	public var isAlive : Bool {
		return self.value != nil
	}

	public init(_ value: T?) {
		self.value = value
	}
}
