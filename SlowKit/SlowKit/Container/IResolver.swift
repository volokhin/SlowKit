import Foundation

public protocol IResolver : class {
	
	func resolve<T>(_ instanceType: T.Type) -> T?
	func resolve<T>(_ instanceType: T.Type, name: String) -> T?

	func resolve<T: INeedArguments>(_ instanceType: T.Type, args: T.Arguments) -> T?
	func resolve<T: INeedArguments>(_ instanceType: T.Type, name: String, args: T.Arguments) -> T?

	func contains<T>(_ instanceType: T.Type) -> Bool
	func contains<T>(_ instanceType: T.Type, name: String) -> Bool
}
