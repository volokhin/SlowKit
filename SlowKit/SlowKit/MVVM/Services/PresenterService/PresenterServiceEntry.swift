import Foundation
import UIKit

internal class PresenterServiceEntry<TViewModel: ViewControllerViewModelBase> {

	internal var params: [(TViewModel) -> Void] = []
	internal var onDidPresent: [(TViewModel) -> Void] = []
	internal var transition: UIViewControllerAnimatedTransitioning?
	
}
