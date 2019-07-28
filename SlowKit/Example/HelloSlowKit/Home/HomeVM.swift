import Foundation
import SlowKit

class HomeVM : ViewControllerViewModelBase {

	public let service: IHomeService

	public var text: String = "" {
		didSet {
			self.viewModelChanged.raise()
		}
	}

	public init(service: IHomeService) {
		self.service = service
	}

	override func willAppear() {
		super.willAppear()

		self.text = "Loading..."
		self.service.fetchText {
			[weak self] result in
			guard let self = self else { return }
			self.text = result
		}
	}

}
