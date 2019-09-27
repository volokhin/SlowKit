import Foundation
import UIKit

class TransitioningDelegate : NSObject, UIViewControllerTransitioningDelegate {

	private let transition: UIViewControllerAnimatedTransitioning?

	init(transition: UIViewControllerAnimatedTransitioning?) {
		self.transition = transition
	}

	public func animationController(
		forPresented presented: UIViewController,
		presenting: UIViewController,
		source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

		return self.transition
	}
}
