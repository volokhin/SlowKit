import UIKit

public class BindableCollectionView : UIView {

	public let collection: UICollectionView
	public var templateSelector: ICellTemplateSelector = DefaultCellTemplateSelector()

	public var dataSource: IDataSource? {
		didSet {
			self.unsubscribe(from: oldValue)
			self.subscribe(to: self.dataSource)
			self.collection.reloadData()
		}
	}

	public let firstCellWillLoad: Event<Void> = Event()
	public let scrollViewDidScroll: Event<UIScrollView> = Event()

	private var registeredTemplates: Set<AnyCellTemplate> = []
	private var isFirstCellLoaded: Bool = false

	public init(layout: UICollectionViewLayout) {
		self.collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
		super.init(frame: .zero)
		self.commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		self.collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		super.init(coder: aDecoder)
		self.commonInit()
	}

	private func commonInit() {
		self.backgroundColor = .clear
		self.collection.dataSource = self
		self.collection.delegate = self
		self.collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "default")
		self.addSubview(self.collection)
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		self.collection.frame = self.bounds
	}

	private func unsubscribe(from dataSource: IDataSource?) {
		guard let dataSource = dataSource else { return }
		dataSource.reloaded.unsubscribe(self)
	}

	private func subscribe(to dataSource: IDataSource?) {
		guard let dataSource = dataSource else { return }

		dataSource.reloaded.subscribe(self) {
			this in
			this.collection.reloadData()
		}

		dataSource.added.subscribe(self) {
			this, count in
			let startIndex = this.collection.numberOfItems(inSection: 0)
			let idsToAdd = (0..<count).map { IndexPath(row: startIndex + $0, section: 0) }
			this.collection.insertItems(at: idsToAdd)
		}

		dataSource.replaced.subscribe(self) {
			this, args in
			let startIndex = args.range.startIndex
			let idsToDelete = args.range.map { IndexPath(row: $0, section: 0) }
			let idsToAdd = (0..<args.count).map { IndexPath(row: startIndex + $0, section: 0) }
			this.collection.performBatchUpdates({
				this.collection.deleteItems(at: idsToDelete)
				this.collection.insertItems(at: idsToAdd)

			}, completion: nil)
		}
	}
}

extension BindableCollectionView : UICollectionViewDataSource {

	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.dataSource?.count ?? 0
	}

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		self.riseFirstCellWillLoadIfNeeded()
		if let dataSource = self.dataSource, let item = dataSource.item(at: indexPath.row) {
			if let template = self.templateSelector.template(for: item) {
				self.registerIfNeeded(template, in: collectionView)
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: template.reuseIdentifier, for: indexPath)
				if var cell = cell as? IHaveViewModel {
					cell.viewModelObject = item as? ViewModelBase
				}
				return cell
			}
		}
		return collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
	}

	private func riseFirstCellWillLoadIfNeeded() {
		if !self.isFirstCellLoaded {
			self.isFirstCellLoaded = true
			self.firstCellWillLoad.raise()
		}
	}

	private func registerIfNeeded(_ template: AnyCellTemplate, in collectionView: UICollectionView) {
		guard !self.registeredTemplates.contains(template) else { return }
		template.register(in: collectionView)
		self.registeredTemplates.insert(template)
	}
}

extension BindableCollectionView : UICollectionViewDelegateFlowLayout {

	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return collectionView.bounds.size
	}

	public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if let dataSource = self.dataSource, let item = dataSource.item(at: indexPath.row) as? CellViewModelBase {
			item.willDisplay()
		}
	}

	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.scrollViewDidScroll.raise(scrollView)
	}
}
