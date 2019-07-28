import Foundation

public protocol ICellTemplate {
	var reuseIdentifier: String { get }
	func register(in tableView: UITableView)
	func register(in collectionView: UICollectionView)
}
