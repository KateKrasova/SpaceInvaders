//
//  GameViewController.swift
//  SpaceInvaders
//
//  Created by Kate on 05.10.2023.
//

import UIKit

final class GameViewController: UIViewController {
    // MARK: - Private props

    private let moduleView = GameView()

    // MARK: - Lyfecycle

    override func loadView() {
        view = moduleView
        moduleView.alertClosure = { [weak self] in
            let alertController = UIAlertController(title: "Ooops", message: "GAME OVER", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default) { _ in 
                self?.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)

            self?.present(alertController, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
