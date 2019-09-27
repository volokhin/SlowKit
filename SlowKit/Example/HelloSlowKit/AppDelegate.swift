import UIKit
import SlowKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	private let container = Container(log: ConsoleLog())
	var window: UIWindow?

	override init() {
		super.init()

		self.container.register(IHomeService.self)
			.withInit(HomeService.init)
			.singleInstance()

		self.container.register(HomeVM.self)
			.withInit(HomeVM.init)

		self.container.register(HomeVC.self)
			.withInit(HomeVC.init)
			.onDidCreate { (c, vc) in
				vc.viewModel = c.resolve(HomeVM.self)
		}
	}

	func application(
		_ application: UIApplication,
		willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		self.window = UIWindow()
		let root = self.container.resolve(HomeVC.self)
		self.window?.rootViewController = root
		self.window?.makeKeyAndVisible()
		return true
	}
}
