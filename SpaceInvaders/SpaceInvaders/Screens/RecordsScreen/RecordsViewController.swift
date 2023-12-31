//
//  RecordsViewController.swift
//  SpaceInvaders
//
//  Created by Kate on 05.10.2023.
//

import UIKit

final class RecordsViewController: UIViewController {
    // MARK: - Private props

    private let moduleView = RecordsView()

    // MARK: - Lyfecycle

    override func loadView() {
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let items = UserDefaultsService.userRecords else {return}
        moduleView.render(items.sorted(by: { $0.points > $1.points }))
    }
}
