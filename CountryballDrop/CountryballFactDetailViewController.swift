//
//  CountryballFactDetailViewController.swift
//  CountryballDrop
//

import UIKit

final class CountryballFactDetailViewController: UIViewController {

    private let fact: CountryballFact

    private let scrollView = UIScrollView()
    private let stack = UIStackView()

    init(fact: CountryballFact) {
        self.fact = fact
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 158/255, green: 217/255, blue: 218/255, alpha: 1)
        title = fact.displayTitle

        if let nav = navigationController, nav.presentingViewController != nil, nav.viewControllers.first === self {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .done,
                target: self,
                action: #selector(doneTapped)
            )
        }

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)

        let hero = UIImageView(image: UIImage(named: fact.id))
        hero.contentMode = .scaleAspectFit
        hero.layer.cornerRadius = 16
        hero.clipsToBounds = true
        hero.backgroundColor = UIColor(white: 1, alpha: 0.35)
        hero.heightAnchor.constraint(equalToConstant: 180).isActive = true
        stack.addArrangedSubview(hero)

        stack.addArrangedSubview(block(title: "Capital", body: fact.capital))
        stack.addArrangedSubview(block(title: "National dish", body: fact.nationalDish))
        stack.addArrangedSubview(block(title: "Fun fact", body: fact.funFact))

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40)
        ])
    }

    @objc private func doneTapped() {
        dismiss(animated: true)
    }

    private func block(title: String, body: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = UIColor(white: 0.35, alpha: 1)

        let bodyLabel = UILabel()
        bodyLabel.text = body
        bodyLabel.font = .systemFont(ofSize: 17, weight: .regular)
        bodyLabel.textColor = UIColor(white: 0.12, alpha: 1)
        bodyLabel.numberOfLines = 0

        let v = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        v.axis = .vertical
        v.spacing = 6
        v.alignment = .fill
        return v
    }
}
