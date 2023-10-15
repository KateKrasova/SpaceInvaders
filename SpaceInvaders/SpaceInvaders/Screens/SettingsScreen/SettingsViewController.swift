//
//  SettingsViewController.swift
//  SpaceInvaders
//
//  Created by Kate on 05.10.2023.
//

import UIKit

final class SettingsViewController: UIViewController {
    // MARK: - Private props

    private let moduleView = SettingsView()

    // MARK: - Lyfecycle

    override func loadView() {
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = UserDefaultsService.user else {return}
        moduleView.updateInfo(info: .init(userName: user.name, ship: user.ship, level: user.level))
    }

    override func viewWillDisappear(_ animated: Bool) {
        moduleView.saveSettings()
    }
}
