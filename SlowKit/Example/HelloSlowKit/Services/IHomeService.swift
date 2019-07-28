import Foundation

protocol IHomeService {
	func fetchText(completion: @escaping (String) -> Void)
}
