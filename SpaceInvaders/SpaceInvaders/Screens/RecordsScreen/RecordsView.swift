//
//  RecordsView.swift
//  SpaceInvaders
//
//  Created by Kate on 05.10.2023.
//

import UIKit

final class RecordsView: UIView {
    // MARK: - Private Props

    private var items: [UserDataModel] = []

    // MARK: - Views

    private lazy var recordsLabel = UILabel().do {
        $0.text = "Here you can see your records"
        $0.textColor = Asset.Colors.redMain.color
        $0.font = .systemFont(ofSize: Constants.font24, weight: .bold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private lazy var infoLabel = UILabel().do {
        $0.text = "Oops \nNow it's empty"
        $0.textColor = Asset.Colors.yellowMain.color
        $0.font = .systemFont(ofSize: Constants.font32, weight: .bold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private lazy var recordsTableView = UITableView().do {
        $0.register(RecordsTableViewCell.self)

        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .black
    }

    // MARK: - LifeCycle

    init() {
        super.init(frame: .zero)

        setup()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Methods

extension RecordsView {
    func render(_ info: [UserDataModel]) {
        items = info

        if items.isEmpty {
            recordsTableView.isHidden = true
        } else {
            recordsTableView.isHidden = false
        }

        recordsTableView.reloadData()
    }
}

// MARK: - Private Methods

private extension RecordsView {
    func setup() {
        backgroundColor = .black

        addSubviews(
            recordsLabel,
            infoLabel,
            recordsTableView
        )
    }

    func setupConstraints() {
        recordsLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.offset32)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Constants.offset16)
        }

        recordsTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(recordsLabel.snp.bottom).offset(Constants.offset16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }

        infoLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension RecordsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        return tableView.dequeueReusableCell(withClass: RecordsTableViewCell.self, for: indexPath).do {
            $0.updateViews(.init(number: indexPath.row + 1, name: item.name, points: item.points, level: item.level))
        }
    }
}

// MARK: - Constants

private extension RecordsView {
    enum Constants {
        static let font24: CGFloat = 24
        static let font32: CGFloat = 32

        static let offset32: CGFloat = 32
        static let offset16: CGFloat = 16
    }
}
