import Foundation
import UIKit

public class BindableImageView : UIImageView {

	private let queue = DispatchQueue.global(qos: .userInitiated)

	public var imageURL: URL? = nil {
		didSet {
			if oldValue != self.imageURL {
				self.loadImage(from: self.imageURL)
			}
		}
	}

	private func loadImage(from url: URL?) {
		if let url = url {
			self.downloadImage(from: url)
		} else {
			self.image = nil
		}
	}

	private func downloadImage(from url: URL) {
		let request = URLRequest(url: url)
		self.image = nil
		self.queue.async {
			if let data = URLCache.shared.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
				DispatchQueue.main.async {
					[weak self] in
					guard let self = self else { return }
					guard self.imageURL == url else { return }
					self.image = image
				}
			} else {
				let task = URLSession.shared.dataTask(with: url) {
					(data, response, error) in
					if let error = error {
						print(error.localizedDescription)
					} else if let response = response, let data = data, let image = UIImage(data: data) {
						let cachedData = CachedURLResponse(response: response, data: data)
						URLCache.shared.storeCachedResponse(cachedData, for: request)
						DispatchQueue.main.async {
							[weak self] in
							guard let self = self else { return }
							guard self.imageURL == url else { return }
							self.setImageWithTransition(image)
						}
					}
				}
				task.resume()
			}
		}
	}

	private func setImageWithTransition(_ image: UIImage) {
		UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {
			self.image = image
		}, completion: nil)
	}

}
