//
//  ExampleMainViewController.swift
//  Authentication
//
//  Created by Daniela Riesgo on 3/16/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift

final class ExampleMainViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!

    override func viewDidLoad() {
        logoutButton.reactive.controlEvents(.touchUpInside)
            .observe(on: UIScheduler())
            .observeValues { _ in
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.sessionService.logOut()
                    appDelegate.authenticationCoordinator.start()
                }
        }
    }

}
