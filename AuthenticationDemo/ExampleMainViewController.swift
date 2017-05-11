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
import Authentication

final class ExampleMainViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!

    var sessionService: ExampleSessionService?

    override func viewDidLoad() {
        logoutButton.reactive.controlEvents(.touchUpInside)
            .observe(on: UIScheduler())
            .observeValues { [unowned self] _ in

        }
    }

}
