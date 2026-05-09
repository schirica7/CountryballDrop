//
//  CountryballCollectionViewController.swift
//  CountryballDrop
//

import UIKit

final class CountryballCollectionViewController: UICollectionViewController {

    private static let cellReuse = "BallCell"

    private let ballIds = UnlockedCountryballsStore.europeanIds

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 24, right: 16)
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collection"
        collectionView.backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        collectionView.register(BallCollectionCell.self, forCellWithReuseIdentifier: Self.cellReuse)

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(backToMenu)
        )
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.indexPathsForSelectedItems?.forEach { collectionView.deselectItem(at: $0, animated: true) }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let insets = layout.sectionInset.left + layout.sectionInset.right
            let spacing = layout.minimumInteritemSpacing * 2
            let cols: CGFloat = 3
            let w = floor((collectionView.bounds.width - insets - spacing) / cols)
            layout.itemSize = CGSize(width: w, height: w + 32)
        }
    }

    @objc private func backToMenu() {
        navigationController?.dismiss(animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ballIds.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.cellReuse, for: indexPath) as! BallCollectionCell
        let id = ballIds[indexPath.item]
        let unlocked = UnlockedCountryballsStore.isUnlocked(id)
        cell.configure(id: id, unlocked: unlocked)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = ballIds[indexPath.item]
        guard UnlockedCountryballsStore.isUnlocked(id) else { return }
        guard let fact = CountryballFacts.info(for: id) else { return }
        let detail = CountryballFactDetailViewController(fact: fact)
        navigationController?.pushViewController(detail, animated: true)
    }
}

// MARK: - Cell

final class BallCollectionCell: UICollectionViewCell {

    private enum Colors {
        static let primaryText = UIColor(white: 0.12, alpha: 1)
        static let secondaryText = UIColor(white: 0.43, alpha: 1)
        static let unlockedCardFill = UIColor(white: 1, alpha: 0.55)
        static let lockedCardFill = UIColor(white: 0.92, alpha: 1)
        /// Single-color silhouette for locked balls.
        static let silhouetteTint = UIColor(white: 0.32, alpha: 1)
    }

    private let imageView = UIImageView()
    private let caption = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false

        caption.font = .systemFont(ofSize: 13, weight: .semibold)
        caption.textAlignment = .center
        caption.numberOfLines = 2
        caption.adjustsFontSizeToFitWidth = true
        caption.minimumScaleFactor = 0.7
        caption.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imageView)
        contentView.addSubview(caption)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            caption.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            caption.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            caption.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            caption.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(id: String, unlocked: Bool) {
        caption.text = UnlockedCountryballsStore.displayTitle(for: id)

        let img = UIImage(named: id)
        imageView.layer.borderWidth = 0
        imageView.layer.shadowOpacity = 0
        imageView.layer.shadowRadius = 0
        imageView.layer.shadowOffset = .zero

        if unlocked {
            imageView.image = img?.withRenderingMode(.alwaysOriginal)
            imageView.tintColor = nil
            imageView.alpha = 1
            imageView.layer.masksToBounds = true
            caption.textColor = Colors.primaryText
            contentView.backgroundColor = Colors.unlockedCardFill
            contentView.layer.cornerRadius = 12
        } else {
            if let img = img {
                imageView.image = img.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = Colors.silhouetteTint
                imageView.alpha = 1
                imageView.layer.masksToBounds = false
                imageView.layer.shadowColor = UIColor.black.cgColor
                imageView.layer.shadowOpacity = 0.35
                imageView.layer.shadowRadius = 6
                imageView.layer.shadowOffset = CGSize(width: 0, height: 3)
            } else {
                imageView.image = nil
                imageView.tintColor = nil
                imageView.alpha = 1
                imageView.layer.masksToBounds = true
            }
            caption.textColor = Colors.secondaryText
            contentView.backgroundColor = Colors.lockedCardFill
            contentView.layer.cornerRadius = 12
        }
        contentView.layoutMargins = .zero

        accessibilityLabel = unlocked
            ? "Unlocked, \(caption.text ?? id)"
            : "Locked"
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.layer.borderWidth = 0
        imageView.layer.shadowOpacity = 0
        imageView.layer.shadowRadius = 0
        imageView.tintColor = nil
        imageView.image = nil
    }
}
