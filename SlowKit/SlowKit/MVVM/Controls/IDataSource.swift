import Foundation

public protocol IDataSource {
	var count: Int { get }
	var reloaded: Event<Void> { get }
	var added: Event<Int> { get }
	var replaced: Event<(range: Range<Int>, count: Int)> { get }
	func item(at index: Int) -> Any?
}
