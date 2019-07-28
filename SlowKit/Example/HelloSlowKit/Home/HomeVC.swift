import UIKit
import SlowKit

class HomeVC: ViewControllerBase<HomeVM> {

	override func loadView() {
		self.view = HomeView.makeFromXib()
	}

}
