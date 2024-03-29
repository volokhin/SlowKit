import Foundation

public class ContainerEntryBuilder<T> {

	private var associatedEntry: ContainerEntry<T>
	private var associatedKeys: [ContainerEntryKey] = []
	private var name: String?

	internal var onAssociatedKeysChanged: ((_ oldValue: [ContainerEntryKey], _ newValue: [ContainerEntryKey]) -> Void)?

	internal init(key: ContainerEntryKey) {
		self.associatedKeys.append(key)
		self.name = key.name
		self.associatedEntry = ContainerEntry<T>()
	}

	@discardableResult
	public func withFactory(_ factory: @escaping (IResolver) -> T?) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = { resolver, _ in factory(resolver) }
		return self
	}

	@discardableResult
	public func withFactory(_ factory: @escaping (IResolver, Any) -> T?) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = factory
		return self
	}

	@discardableResult
	public func forName(_ name: String) -> Self {
		if self.name != name {
			if let oldName = self.name {
				Logger.warning(Messages.redundantNameDeclaration(oldName: oldName,
																 newName: name,
																 instance: T.self))
			}
			self.name = name
			let oldKeys = self.associatedKeys
			let newKeys = self.associatedKeys.map {
				key in
				ContainerEntryKey(instanceType: key.instanceType, name: self.name)
			}
			self.associatedKeys = newKeys
			self.onAssociatedKeysChanged?(oldKeys, newKeys)
		}
		return self
	}

	@discardableResult
	public func perRequest() -> Self {
		if let scope = self.associatedEntry.instanceScope {
			Logger.warning(Messages.redundantScopeDeclaration(oldScope: scope,
															  newScope: .instancePerRequest,
															  instance: T.self))
		}
		self.associatedEntry.instanceScope = .instancePerRequest
		return self
	}

	@discardableResult
	public func singleInstance() -> Self {
		if let scope = self.associatedEntry.instanceScope {
			Logger.warning(Messages.redundantScopeDeclaration(oldScope: scope,
															  newScope: .singleInstance,
															  instance: T.self))
		}
		self.associatedEntry.instanceScope = .singleInstance
		return self
	}

	@discardableResult
	public func `as`(_ aliasType: Any.Type) -> Self {
		let oldKeys = self.associatedKeys
		let key = ContainerEntryKey(instanceType: aliasType, name: self.name)
		self.associatedKeys.append(key)
		self.onAssociatedKeysChanged?(oldKeys, self.associatedKeys)
		return self
	}

	internal func getEntry() -> ContainerEntry<T> {
		return self.associatedEntry
	}

	private func riseFactoryWarningIfNeeded() {
		if let f = self.associatedEntry.instanceFactory {
			Logger.warning(Messages.redundantFactoryDeclaration(factory: type(of: f),
																instance: T.self))
		}
	}

	// MARK: Events

	@discardableResult
	public func onDidResolve(_ factory: @escaping (IResolver, T) -> Void) -> Self {
		self.associatedEntry.didResolve.append {
			(container, _, _, instance) in
			if let instance = instance {
				factory(container, instance)
			}
		}
		return self
	}

	@discardableResult
	public func onDidCreate(_ factory: @escaping (IResolver, T) -> Void) -> Self {
		self.associatedEntry.didCreate.append {
			(container, _, _, instance) in
			if let instance = instance {
				factory(container, instance)
			}
		}
		return self
	}

	// MARK: Initializers

	@discardableResult
	public func withInit(_ initializer: @escaping () -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			_,_ in
			initializer()
		}
		return self
	}

	@discardableResult
	public func withInit<P>(_ initializer: @escaping (P) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer(resolver.contains(P.self) ? resolver.resolve(P.self)! : args as! P)
		}
		return self
	}

	@discardableResult
	public func withInit<P1, P2>(_ initializer: @escaping ((P1, P2)) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer((resolver.contains(P1.self) ? resolver.resolve(P1.self)! : args as! P1,
						 resolver.contains(P2.self) ? resolver.resolve(P2.self)! : args as! P2))
		}
		return self
	}

	@discardableResult
	public func withInit<P1, P2, P3>(_ initializer: @escaping ((P1, P2, P3)) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer((resolver.contains(P1.self) ? resolver.resolve(P1.self)! : args as! P1,
						 resolver.contains(P2.self) ? resolver.resolve(P2.self)! : args as! P2,
						 resolver.contains(P3.self) ? resolver.resolve(P3.self)! : args as! P3))
		}
		return self
	}

	@discardableResult
	public func withInit<P1, P2, P3, P4>(_ initializer: @escaping ((P1, P2, P3, P4)) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer((resolver.contains(P1.self) ? resolver.resolve(P1.self)! : args as! P1,
						 resolver.contains(P2.self) ? resolver.resolve(P2.self)! : args as! P2,
						 resolver.contains(P3.self) ? resolver.resolve(P3.self)! : args as! P3,
						 resolver.contains(P4.self) ? resolver.resolve(P4.self)! : args as! P4))
		}
		return self
	}

	@discardableResult
	public func withInit<P1, P2, P3, P4, P5>(_ initializer: @escaping ((P1, P2, P3, P4, P5)) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer((resolver.contains(P1.self) ? resolver.resolve(P1.self)! : args as! P1,
						 resolver.contains(P2.self) ? resolver.resolve(P2.self)! : args as! P2,
						 resolver.contains(P3.self) ? resolver.resolve(P3.self)! : args as! P3,
						 resolver.contains(P4.self) ? resolver.resolve(P4.self)! : args as! P4,
						 resolver.contains(P5.self) ? resolver.resolve(P5.self)! : args as! P5))
		}
		return self
	}

	@discardableResult
	public func withInit<P1, P2, P3, P4, P5, P6>(_ initializer: @escaping ((P1, P2, P3, P4, P5, P6)) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer((resolver.contains(P1.self) ? resolver.resolve(P1.self)! : args as! P1,
						 resolver.contains(P2.self) ? resolver.resolve(P2.self)! : args as! P2,
						 resolver.contains(P3.self) ? resolver.resolve(P3.self)! : args as! P3,
						 resolver.contains(P4.self) ? resolver.resolve(P4.self)! : args as! P4,
						 resolver.contains(P5.self) ? resolver.resolve(P5.self)! : args as! P5,
						 resolver.contains(P6.self) ? resolver.resolve(P6.self)! : args as! P6))
		}
		return self
	}

	@discardableResult
	public func withInit<P1, P2, P3, P4, P5, P6, P7>(_ initializer: @escaping ((P1, P2, P3, P4, P5, P6, P7)) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer((resolver.contains(P1.self) ? resolver.resolve(P1.self)! : args as! P1,
						 resolver.contains(P2.self) ? resolver.resolve(P2.self)! : args as! P2,
						 resolver.contains(P3.self) ? resolver.resolve(P3.self)! : args as! P3,
						 resolver.contains(P4.self) ? resolver.resolve(P4.self)! : args as! P4,
						 resolver.contains(P5.self) ? resolver.resolve(P5.self)! : args as! P5,
						 resolver.contains(P6.self) ? resolver.resolve(P6.self)! : args as! P6,
						 resolver.contains(P7.self) ? resolver.resolve(P7.self)! : args as! P7))
		}
		return self
	}

	@discardableResult
	public func withInit<P1, P2, P3, P4, P5, P6, P7, P8>(_ initializer: @escaping ((P1, P2, P3, P4, P5, P6, P7, P8)) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer((resolver.contains(P1.self) ? resolver.resolve(P1.self)! : args as! P1,
						 resolver.contains(P2.self) ? resolver.resolve(P2.self)! : args as! P2,
						 resolver.contains(P3.self) ? resolver.resolve(P3.self)! : args as! P3,
						 resolver.contains(P4.self) ? resolver.resolve(P4.self)! : args as! P4,
						 resolver.contains(P5.self) ? resolver.resolve(P5.self)! : args as! P5,
						 resolver.contains(P6.self) ? resolver.resolve(P6.self)! : args as! P6,
						 resolver.contains(P7.self) ? resolver.resolve(P7.self)! : args as! P7,
						 resolver.contains(P8.self) ? resolver.resolve(P8.self)! : args as! P8))
		}
		return self
	}

	@discardableResult
	public func withInit<P1, P2, P3, P4, P5, P6, P7, P8, P9>(_ initializer: @escaping ((P1, P2, P3, P4, P5, P6, P7, P8, P9)) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer((resolver.contains(P1.self) ? resolver.resolve(P1.self)! : args as! P1,
						 resolver.contains(P2.self) ? resolver.resolve(P2.self)! : args as! P2,
						 resolver.contains(P3.self) ? resolver.resolve(P3.self)! : args as! P3,
						 resolver.contains(P4.self) ? resolver.resolve(P4.self)! : args as! P4,
						 resolver.contains(P5.self) ? resolver.resolve(P5.self)! : args as! P5,
						 resolver.contains(P6.self) ? resolver.resolve(P6.self)! : args as! P6,
						 resolver.contains(P7.self) ? resolver.resolve(P7.self)! : args as! P7,
						 resolver.contains(P8.self) ? resolver.resolve(P8.self)! : args as! P8,
						 resolver.contains(P9.self) ? resolver.resolve(P9.self)! : args as! P9))
		}
		return self
	}

	@discardableResult
	public func withInit<P1, P2, P3, P4, P5, P6, P7, P8, P9, P10>(_ initializer: @escaping ((P1, P2, P3, P4, P5, P6, P7, P8, P9, P10)) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer((resolver.contains(P1.self) ? resolver.resolve(P1.self)! : args as! P1,
						 resolver.contains(P2.self) ? resolver.resolve(P2.self)! : args as! P2,
						 resolver.contains(P3.self) ? resolver.resolve(P3.self)! : args as! P3,
						 resolver.contains(P4.self) ? resolver.resolve(P4.self)! : args as! P4,
						 resolver.contains(P5.self) ? resolver.resolve(P5.self)! : args as! P5,
						 resolver.contains(P6.self) ? resolver.resolve(P6.self)! : args as! P6,
						 resolver.contains(P7.self) ? resolver.resolve(P7.self)! : args as! P7,
						 resolver.contains(P8.self) ? resolver.resolve(P8.self)! : args as! P8,
						 resolver.contains(P9.self) ? resolver.resolve(P9.self)! : args as! P9,
						 resolver.contains(P10.self) ? resolver.resolve(P10.self)! : args as! P10))
		}
		return self
	}

	@discardableResult
	public func withInit<P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11>(_ initializer: @escaping ((P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11)) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer((resolver.contains(P1.self) ? resolver.resolve(P1.self)! : args as! P1,
						 resolver.contains(P2.self) ? resolver.resolve(P2.self)! : args as! P2,
						 resolver.contains(P3.self) ? resolver.resolve(P3.self)! : args as! P3,
						 resolver.contains(P4.self) ? resolver.resolve(P4.self)! : args as! P4,
						 resolver.contains(P5.self) ? resolver.resolve(P5.self)! : args as! P5,
						 resolver.contains(P6.self) ? resolver.resolve(P6.self)! : args as! P6,
						 resolver.contains(P7.self) ? resolver.resolve(P7.self)! : args as! P7,
						 resolver.contains(P8.self) ? resolver.resolve(P8.self)! : args as! P8,
						 resolver.contains(P9.self) ? resolver.resolve(P9.self)! : args as! P9,
						 resolver.contains(P10.self) ? resolver.resolve(P10.self)! : args as! P10,
						 resolver.contains(P11.self) ? resolver.resolve(P11.self)! : args as! P11))
		}
		return self
	}

	@discardableResult
	public func withInit<P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12>(_ initializer: @escaping ((P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12)) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer((resolver.contains(P1.self) ? resolver.resolve(P1.self)! : args as! P1,
						 resolver.contains(P2.self) ? resolver.resolve(P2.self)! : args as! P2,
						 resolver.contains(P3.self) ? resolver.resolve(P3.self)! : args as! P3,
						 resolver.contains(P4.self) ? resolver.resolve(P4.self)! : args as! P4,
						 resolver.contains(P5.self) ? resolver.resolve(P5.self)! : args as! P5,
						 resolver.contains(P6.self) ? resolver.resolve(P6.self)! : args as! P6,
						 resolver.contains(P7.self) ? resolver.resolve(P7.self)! : args as! P7,
						 resolver.contains(P8.self) ? resolver.resolve(P8.self)! : args as! P8,
						 resolver.contains(P9.self) ? resolver.resolve(P9.self)! : args as! P9,
						 resolver.contains(P10.self) ? resolver.resolve(P10.self)! : args as! P10,
						 resolver.contains(P11.self) ? resolver.resolve(P11.self)! : args as! P11,
						 resolver.contains(P12.self) ? resolver.resolve(P12.self)! : args as! P12))
		}
		return self
	}

	@discardableResult
	public func withInit<P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13>(_ initializer: @escaping ((P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13)) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer((resolver.contains(P1.self) ? resolver.resolve(P1.self)! : args as! P1,
						 resolver.contains(P2.self) ? resolver.resolve(P2.self)! : args as! P2,
						 resolver.contains(P3.self) ? resolver.resolve(P3.self)! : args as! P3,
						 resolver.contains(P4.self) ? resolver.resolve(P4.self)! : args as! P4,
						 resolver.contains(P5.self) ? resolver.resolve(P5.self)! : args as! P5,
						 resolver.contains(P6.self) ? resolver.resolve(P6.self)! : args as! P6,
						 resolver.contains(P7.self) ? resolver.resolve(P7.self)! : args as! P7,
						 resolver.contains(P8.self) ? resolver.resolve(P8.self)! : args as! P8,
						 resolver.contains(P9.self) ? resolver.resolve(P9.self)! : args as! P9,
						 resolver.contains(P10.self) ? resolver.resolve(P10.self)! : args as! P10,
						 resolver.contains(P11.self) ? resolver.resolve(P11.self)! : args as! P11,
						 resolver.contains(P12.self) ? resolver.resolve(P12.self)! : args as! P12,
						 resolver.contains(P13.self) ? resolver.resolve(P13.self)! : args as! P13))
		}
		return self
	}

	@discardableResult
	public func withInit<P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14>(_ initializer: @escaping ((P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14)) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer((resolver.contains(P1.self) ? resolver.resolve(P1.self)! : args as! P1,
						 resolver.contains(P2.self) ? resolver.resolve(P2.self)! : args as! P2,
						 resolver.contains(P3.self) ? resolver.resolve(P3.self)! : args as! P3,
						 resolver.contains(P4.self) ? resolver.resolve(P4.self)! : args as! P4,
						 resolver.contains(P5.self) ? resolver.resolve(P5.self)! : args as! P5,
						 resolver.contains(P6.self) ? resolver.resolve(P6.self)! : args as! P6,
						 resolver.contains(P7.self) ? resolver.resolve(P7.self)! : args as! P7,
						 resolver.contains(P8.self) ? resolver.resolve(P8.self)! : args as! P8,
						 resolver.contains(P9.self) ? resolver.resolve(P9.self)! : args as! P9,
						 resolver.contains(P10.self) ? resolver.resolve(P10.self)! : args as! P10,
						 resolver.contains(P11.self) ? resolver.resolve(P11.self)! : args as! P11,
						 resolver.contains(P12.self) ? resolver.resolve(P12.self)! : args as! P12,
						 resolver.contains(P13.self) ? resolver.resolve(P13.self)! : args as! P13,
						 resolver.contains(P14.self) ? resolver.resolve(P14.self)! : args as! P14))
		}
		return self
	}

	@discardableResult
	public func withInit<P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15>(_ initializer: @escaping ((P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15)) -> T) -> Self {
		self.riseFactoryWarningIfNeeded()
		self.associatedEntry.instanceFactory = {
			resolver, args in
			initializer((resolver.contains(P1.self) ? resolver.resolve(P1.self)! : args as! P1,
						 resolver.contains(P2.self) ? resolver.resolve(P2.self)! : args as! P2,
						 resolver.contains(P3.self) ? resolver.resolve(P3.self)! : args as! P3,
						 resolver.contains(P4.self) ? resolver.resolve(P4.self)! : args as! P4,
						 resolver.contains(P5.self) ? resolver.resolve(P5.self)! : args as! P5,
						 resolver.contains(P6.self) ? resolver.resolve(P6.self)! : args as! P6,
						 resolver.contains(P7.self) ? resolver.resolve(P7.self)! : args as! P7,
						 resolver.contains(P8.self) ? resolver.resolve(P8.self)! : args as! P8,
						 resolver.contains(P9.self) ? resolver.resolve(P9.self)! : args as! P9,
						 resolver.contains(P10.self) ? resolver.resolve(P10.self)! : args as! P10,
						 resolver.contains(P11.self) ? resolver.resolve(P11.self)! : args as! P11,
						 resolver.contains(P12.self) ? resolver.resolve(P12.self)! : args as! P12,
						 resolver.contains(P13.self) ? resolver.resolve(P13.self)! : args as! P13,
						 resolver.contains(P14.self) ? resolver.resolve(P14.self)! : args as! P14,
						 resolver.contains(P15.self) ? resolver.resolve(P15.self)! : args as! P15))
		}
		return self
	}
}
