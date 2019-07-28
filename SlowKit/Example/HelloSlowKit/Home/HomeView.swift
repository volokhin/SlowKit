import Foundation
import SlowKit

class HomeView : ViewBase<HomeVM>, IFromXib {

	@IBOutlet weak var textLabel: UILabel!
	
	override func viewModelChanged() {
		super.viewModelChanged()

		self.textLabel.text = self.viewModel?.text
	}
	
}
