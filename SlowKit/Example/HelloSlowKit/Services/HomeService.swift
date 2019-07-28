import Foundation

class HomeService : IHomeService {

	func fetchText(completion: @escaping (String) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
			completion("Hello MVVM!")
		}
	}

}
