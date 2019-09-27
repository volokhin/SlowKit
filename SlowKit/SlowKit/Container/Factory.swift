import Foundation

public class Factory<T: INeedArguments> : IContainerAutoCreate {

	private unowned let resolver: IResolver

	required internal init(resolver: IResolver) {
		self.resolver = resolver
	}

	public func make(_ args: T.Arguments) -> T? {
		return self.resolver.resolve(T.self, args: args)
	}

}
